import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_user/presentation/cubit/current_user_cubit.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../domain/usecases/get_followed_users_posts.dart';

part 'feed_event.dart';

part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetFollowedUsersPosts _getFollowedUsersPosts;
  final CurrentUserCubit _currentUserCubit;
  static const int _pageSize = 10;

  FeedBloc({
    required GetFollowedUsersPosts getFollowedUsersPosts,
    required CurrentUserCubit currentUserCubit,
  }) : _getFollowedUsersPosts = getFollowedUsersPosts,
       _currentUserCubit = currentUserCubit,
       super(const FeedState()) {
    on<FeedFetchInitialPosts>(_onFetchInitialPosts);
    on<FeedFetchNextPage>(_onFetchNextPage);
    on<FeedRefreshRequested>(_onRefreshRequested);
  }

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
}
