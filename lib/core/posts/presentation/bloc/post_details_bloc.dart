import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_event.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_state.dart';
import '../../domain/entities/comment.dart';
import '../../domain/usecases/add_comment.dart';
import '../../domain/usecases/get_post_by_id.dart';
import '../../domain/usecases/get_post_comments.dart';
import '../../domain/usecases/toggle_lilke_post.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final GetPostById _getPostById;
  final ToggleLikePost _toggleLikePost;
  final GetPostComments _getPostComments;
  final AddComment _addComment;

  PostDetailBloc({
    required GetPostById getPostById,
    required ToggleLikePost toggleLikePost,
    required GetPostComments getPostComments,
    required AddComment addComment,
  }) : _getPostById = getPostById,
       _toggleLikePost = toggleLikePost,
       _getPostComments = getPostComments,
       _addComment = addComment,
       super(const PostDetailInitial()) {
    on<PostDetailEvent>((event, emit) async {
      // 1. Safely extract existing data from whichever state is active
      final dynamic existingPost = switch (state) {
        PostDetailInitial() => null,
        PostDetailLoading(post: final p) => p,
        PostDetailSuccess(post: final p) => p,
        PostDetailFailure(post: final p) => p,
      };

      final List<Comment> existingComments = switch (state) {
        PostDetailInitial() => const [],
        PostDetailLoading(comments: final c) => c,
        PostDetailSuccess(comments: final c) => c,
        PostDetailFailure(comments: final c) => c,
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
      }
    });
  }

  /// Manages pulling single entity records securely through the domain layer pipeline.
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

  /// Processes the asynchronous Supabase database like/unlike interaction routines.

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
        // Manually increment the counter right here in memory
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
}
