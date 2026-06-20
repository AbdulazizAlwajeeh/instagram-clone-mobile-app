import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_event.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_state.dart';
import '../../domain/usecases/get_post_by_id.dart';
import '../../domain/usecases/toggle_lilke_post.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final GetPostById _getPostById;
  final ToggleLikePost _toggleLikePost;

  PostDetailBloc({
    required GetPostById getPostById,
    required ToggleLikePost toggleLikePost,
  }) : _getPostById = getPostById,
       _toggleLikePost = toggleLikePost,
       super(const PostDetailInitial()) {
    on<PostDetailEvent>((event, emit) async {
      // 1. Safely extract existing data from whichever state is active
      final dynamic existingPost = switch (state) {
        PostDetailInitial() => null,
        PostDetailLoading(post: final p) => p,
        PostDetailSuccess(post: final p) => p,
        PostDetailFailure(post: final p) => p,
      };

      // 2. Separate logic based on the incoming event class type
      switch (event) {
        case PostDetailFetchRequested():
          emit(const PostDetailLoading(post: null));
          await _handleFetchOrRefresh(event.postId, null, emit); // Blank screen
        // loader on first load
        case PostDetailRefreshRequested():
          emit(PostDetailLoading(post: existingPost));
          await _handleFetchOrRefresh(event.postId, existingPost, emit); //
        // Pull to refresh
        case PostDetailLikeTapped():
          // Handle like mutation details
          await _handleToggleLike(event.postId, existingPost, emit);
      }
    });
  }

  /// Manages pulling single entity records securely through the domain layer pipeline.
  Future<void> _handleFetchOrRefresh(
    String postId,
    dynamic existingPost,
    Emitter<PostDetailState> emit,
  ) async {
    final failureOrPost = await _getPostById(postId);

    failureOrPost.fold(
      (failure) => emit(PostDetailFailure(failure.message, post: existingPost)),
      (post) => emit(PostDetailSuccess(post)),
    );
  }

  /// Processes the asynchronous Supabase database like/unlike interaction routines.

  Future<void> _handleToggleLike(
    String postId,
    dynamic existingPost,
    Emitter<PostDetailState> emit,
  ) async {
    final failureOrUnit = await _toggleLikePost(postId);

    failureOrUnit.fold(
      // Failures will emit error messages safely while tracking active view data
      (failure) => emit(PostDetailFailure(failure.message, post: existingPost)),

      // On structural mutation success, trigger a silent fetch to keep state fresh with Supabase updates
      (_) => add(PostDetailRefreshRequested(postId: postId)),
    );
  }
}
