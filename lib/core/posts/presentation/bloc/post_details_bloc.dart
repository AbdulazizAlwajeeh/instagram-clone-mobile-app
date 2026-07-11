import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_event.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_state.dart';
import '../../domain/entities/comment.dart';
import '../../domain/usecases/add_comment.dart';
import '../../domain/usecases/get_post_by_id.dart';
import '../../domain/usecases/get_post_comments.dart';
import '../../domain/usecases/report_post.dart';
import '../../domain/usecases/toggle_lilke_post.dart';

/// Presentation-layer Bloc coordinating detail view lifecycles for individual posts.
///
/// Orchestrates the execution of decoupled business use cases targeting isolated
/// post evaluations, interactive likes, and relational comment tracking streams.
/// Leverages state data caching mechanisms to maintain uninterrupted visual flow
/// across loading, failure, or lazy-evaluation timelines.
class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final GetPostById _getPostById;
  final ToggleLikePost _toggleLikePost;
  final GetPostComments _getPostComments;
  final AddComment _addComment;
  final ReportPost _reportPostUseCase;

  /// Creates a [PostDetailBloc] instance with all domain interactions explicitly injected.
  PostDetailBloc({
    required GetPostById getPostById,
    required ToggleLikePost toggleLikePost,
    required GetPostComments getPostComments,
    required AddComment addComment,
    required ReportPost reportPost,
  }) : _getPostById = getPostById,
       _toggleLikePost = toggleLikePost,
       _getPostComments = getPostComments,
       _addComment = addComment,
       _reportPostUseCase = reportPost,
       super(const PostDetailInitial()) {
    on<PostDetailEvent>((event, emit) async {
      // 1. Safely extract existing data from whichever state is active
      // Uses Dart pattern matching switches to preserve existing data across visually jarring jumps.
      final dynamic existingPost = switch (state) {
        PostDetailInitial() => null,
        PostDetailLoading(post: final p) => p,
        PostDetailSuccess(post: final p) => p,
        PostDetailFailure(post: final p) => p,
        ReportingPostInProgress(post: final p) => p,
        ReportingPostFailure(post: final p) => p,
        ReportingPostSuccess(post: final p) => p,
      };

      final List<Comment> existingComments = switch (state) {
        PostDetailInitial() => const [],
        PostDetailLoading(comments: final c) => c,
        PostDetailSuccess(comments: final c) => c,
        PostDetailFailure(comments: final c) => c,
        ReportingPostInProgress(comments: final c) => c,
        ReportingPostFailure(comments: final c) => c,
        ReportingPostSuccess(comments: final c) => c,
      };

      // 2. Separate logic based on the incoming event class type
      switch (event) {
        case PostDetailFetchRequested():
          emit(const PostDetailLoading(post: null, comments: []));
          await _handleFetchOrRefresh(
            event.postId,
            null,
            existingComments,
            emit,
          );

        case PostDetailRefreshRequested():
          emit(
            PostDetailLoading(post: existingPost, comments: existingComments),
          );
          await _handleFetchOrRefresh(
            event.postId,
            existingPost,
            existingComments,
            emit,
          );

        case PostDetailLikeTapped():
          await _handleToggleLike(
            event.postId,
            existingPost,
            existingComments,
            emit,
          );

        case PostDetailCommentsFetchRequested():
          emit(
            PostDetailLoading(post: existingPost, comments: existingComments),
          );
          await _handleFetchComments(event.postId, existingPost, emit);

        case PostDetailCommentSubmitted():
          await _handleSubmitComment(
            event.postId,
            event.text,
            existingPost,
            existingComments,
            emit,
          );

        case PostReportSubmitted():
          await _handleReportPost(
            event.postId,
            existingPost,
            existingComments,
            emit,
          );
      }
    });
  }

  Future<void> _handleFetchOrRefresh(
    String postId,
    dynamic existingPost,
    List<Comment> existingComments,
    Emitter<PostDetailState> emit,
  ) async {
    final failureOrPost = await _getPostById(postId);

    failureOrPost.fold(
      (failure) => emit(
        PostDetailFailure(
          failure.message,
          post: existingPost,
          comments: existingComments,
        ),
      ),
      (post) => emit(PostDetailSuccess(post, comments: existingComments)),
    );
  }

  Future<void> _handleToggleLike(
    String postId,
    dynamic existingPost,
    List<Comment> existingComments,
    Emitter<PostDetailState> emit,
  ) async {
    final failureOrUnit = await _toggleLikePost(postId);

    failureOrUnit.fold(
      // Failures will emit error messages safely while tracking active view data
      (failure) => emit(
        PostDetailFailure(
          failure.message,
          post: existingPost,
          comments: existingComments,
        ),
      ),

      // On structural mutation success, trigger a silent fetch to keep state fresh with Supabase updates
      (_) => add(PostDetailRefreshRequested(postId: postId)),
    );
  }

  Future<void> _handleFetchComments(
    String postId,
    dynamic existingPost,
    Emitter<PostDetailState> emit,
  ) async {
    final failureOrComments = await _getPostComments(postId);

    failureOrComments.fold(
      (failure) => emit(
        PostDetailFailure(
          failure.message,
          post: existingPost,
          comments: const [],
        ),
      ),
      (comments) => emit(PostDetailSuccess(existingPost, comments: comments)),
    );
  }

  Future<void> _handleSubmitComment(
    String postId,
    String text,
    dynamic existingPost,
    List<Comment> existingComments,
    Emitter<PostDetailState> emit,
  ) async {
    final failureOrUnit = await _addComment(
      AddCommentParams(postId: postId, text: text),
    );

    failureOrUnit.fold(
      (failure) => emit(
        PostDetailFailure(
          failure.message,
          post: existingPost,
          comments: existingComments,
        ),
      ),
      (_) {
        // Optimistically increment the numerical metadata layer on runtime memory structures.
        dynamic updatedPost = existingPost;
        if (existingPost != null) {
          try {
            updatedPost = (existingPost as Post).copyWith(
              commentsCount: existingPost.commentsCount + 1,
            );
          } catch (_) {}
        }

        // Emit success so the background post screen changes instantly
        emit(PostDetailSuccess(updatedPost, comments: existingComments));

        // Fetch fresh rows to add the brand new comment inside the bottom sheet instantly
        add(PostDetailCommentsFetchRequested(postId: postId));
      },
    );
  }

  Future<void> _handleReportPost(
    String postId,
    dynamic existingPost,
    List<Comment> existingComments,
    Emitter<PostDetailState> emit,
  ) async {
    // Guard against concurrent double-tap spamming while a report is actively in-flight
    if (state is ReportingPostInProgress) {
      return;
    }

    // Optimistically update the post entity model in client-side memory
    dynamic mutatedPost = existingPost;
    if (existingPost != null) {
      try {
        mutatedPost = (existingPost as Post).copyWith(reportedByMe: true);
      } catch (_) {}
    }

    // Instantly transition to the progress state to allow the UI layer to update optimistically
    emit(ReportingPostInProgress(mutatedPost, existingComments));

    // Dispatch the payload request down into the core domain layer usecase execution timeline
    final failureOrUnit = await _reportPostUseCase(postId);

    failureOrUnit.fold(
      // On network failure, roll back the visual layer instantly to the original un-reported post state
      (failure) => emit(
        ReportingPostFailure(
          failure.message,
          // Restores the pre-mutation baseline post payload data
          existingPost,
          existingComments,
        ),
      ),
      // On structural success, solidify the state by transitioning safely into a permanent Success block
      (_) => emit(ReportingPostSuccess(mutatedPost, existingComments)),
    );
  }
}
