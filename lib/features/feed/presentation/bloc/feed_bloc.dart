import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_user/presentation/cubit/current_user_cubit.dart';
import '../../../../core/posts/domain/entities/comment.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../../../core/posts/domain/usecases/add_comment.dart';
import '../../../../core/posts/domain/usecases/get_post_comments.dart';
import '../../../../core/posts/domain/usecases/toggle_lilke_post.dart';
import '../../domain/usecases/get_followed_users_posts.dart';

part 'feed_event.dart';

part 'feed_state.dart';

/// Business logic component orchestrating social feeds, cursor pagination, likes, and comment features.
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetFollowedUsersPosts _getFollowedUsersPosts;
  final CurrentUserCubit _currentUserCubit;
  static const int _pageSize = 10;
  final ToggleLikePost _toggleLikePost;
  final GetPostComments _getPostComments;
  final AddComment _addComment;

  /// Creates a [FeedBloc] initialized with required domain orchestrator use cases.
  FeedBloc({
    required GetFollowedUsersPosts getFollowedUsersPosts,
    required CurrentUserCubit currentUserCubit,
    required ToggleLikePost toggleLikePost,
    required GetPostComments getPostComments,
    required AddComment addComment,
  }) : _getFollowedUsersPosts = getFollowedUsersPosts,
       _currentUserCubit = currentUserCubit,
       _toggleLikePost = toggleLikePost,
       _getPostComments = getPostComments,
       _addComment = addComment,
       super(const FeedState()) {
    on<FeedFetchInitialPosts>(_onFetchInitialPosts);
    on<FeedFetchNextPage>(_onFetchNextPage);
    on<FeedRefreshRequested>(_onRefreshRequested);
    on<FeedPostLikeTapped>(_onPostLikeTapped);
    on<FeedCommentSubmitted>(_onCommentSubmitted);
    on<CommentsFetchRequested>(_onCommentsFetchRequested);
  }

  /// Internal operational helper handling the main execution flow for primary data retrieval cycles.
  Future<void> _loadInitialPosts({required Emitter<FeedState> emit}) async {
    final currentUserId = _currentUserCubit.state is CurrentUserLoggedIn
        ? (_currentUserCubit.state as CurrentUserLoggedIn).user.id
        : null;

    if (currentUserId == null) {
      emit(
        state.copyWith(
          status: FeedStatus.failure,
          errorMessage: 'User session not found.',
        ),
      );
      return;
    }

    final result = await _getFollowedUsersPosts(
      GetFollowedUsersPostsParams(
        userId: currentUserId,
        limit: _pageSize,
        lastPostTimestamp: null,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FeedStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (posts) => emit(
        state.copyWith(
          status: FeedStatus.success,
          posts: posts,
          hasReachedMax: posts.length < _pageSize,
        ),
      ),
    );
  }

  Future<void> _onFetchInitialPosts(
    FeedFetchInitialPosts event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading, hasReachedMax: false));
    await _loadInitialPosts(emit: emit);
  }

  Future<void> _onRefreshRequested(
    FeedRefreshRequested event,
    Emitter<FeedState> emit,
  ) async {
    await _loadInitialPosts(emit: emit);
  }

  Future<void> _onFetchNextPage(
    FeedFetchNextPage event,
    Emitter<FeedState> emit,
  ) async {
    // Block duplicate calls if we are already loading or reached the end of the feed
    if (state.status == FeedStatus.loading || state.hasReachedMax) return;

    final currentUserId = _currentUserCubit.state is CurrentUserLoggedIn
        ? (_currentUserCubit.state as CurrentUserLoggedIn).user.id
        : null;

    if (currentUserId == null) return;

    // THE CURSOR: Extract creation timestamp from the last item currently at the bottom of the screen
    final DateTime? lastTimestamp = state.posts.isNotEmpty
        ? state.posts.last.createdAt
        : null;

    final result = await _getFollowedUsersPosts(
      GetFollowedUsersPostsParams(
        userId: currentUserId,
        limit: _pageSize,
        lastPostTimestamp: lastTimestamp,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FeedStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (newPosts) {
        if (newPosts.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          emit(
            state.copyWith(
              status: FeedStatus.success,
              posts: List.of(state.posts)
                ..addAll(newPosts), // Append new posts seamlessly
              hasReachedMax: newPosts.length < _pageSize,
            ),
          );
        }
      },
    );
  }

  Future<void> _onPostLikeTapped(
    FeedPostLikeTapped event,
    Emitter<FeedState> emit,
  ) async {
    final result = await _toggleLikePost(event.postId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FeedStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            final currentLikeStatus = post.isLiked;
            return post.copyWith(
              isLiked: !currentLikeStatus,
              likesCount: !currentLikeStatus
                  ? post.likesCount + 1
                  : post.likesCount - 1,
            );
          }
          return post;
        }).toList();

        emit(state.copyWith(posts: updatedPosts));
      },
    );
  }

  void _onCommentSubmitted(
    FeedCommentSubmitted event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(isSubmittingComment: true));

    final result = await _addComment(
      AddCommentParams(postId: event.postId, text: event.text),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          isSubmittingComment: false,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        // Comment added successfully! Now fetch the fresh comments list from
        //the internet
        emit(state.copyWith(isSubmittingComment: true));
        final fetchResult = await _getPostComments(event.postId);

        fetchResult.fold(
          (failure) => emit(
            state.copyWith(
              isSubmittingComment: false,
              errorMessage: failure.message,
            ),
          ),
          (freshComments) {
            final updatedPosts = state.posts.map((post) {
              if (post.id == event.postId) {
                return post.copyWith(commentsCount: post.commentsCount + 1);
              }
              return post;
            }).toList();

            emit(
              state.copyWith(
                isSubmittingComment: false,
                posts: updatedPosts,
                activeComments: freshComments,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onCommentsFetchRequested(
    CommentsFetchRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(isFetchingComments: true, activeComments: []));

    final result = await _getPostComments(event.postId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FeedStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (comments) => emit(
        state.copyWith(isFetchingComments: false, activeComments: comments),
      ),
    );
  }
}
