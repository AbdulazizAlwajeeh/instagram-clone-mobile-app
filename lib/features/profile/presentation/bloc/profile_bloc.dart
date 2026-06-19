import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:yemengram/features/profile/domain/usecases/follow_user.dart';
import 'package:yemengram/features/profile/domain/usecases/unfollow_user.dart';
import '../../../../core/app_user/presentation/cubit/current_user_cubit.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/fetch_user_posts.dart';
import '../../domain/usecases/fetch_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FetchUserProfile _fetchUserProfile;
  final FetchUserPosts _fetchUserPosts;
  final CurrentUserCubit _currentUserCubit;
  final FollowUser _followUser;
  final UnfollowUser _unfollowUser;

  ProfileBloc({
    required FetchUserProfile fetchUserProfile,
    required FetchUserPosts fetchUserPosts,
    required CurrentUserCubit currentUserCubit,
    required FollowUser followUser,
    required UnfollowUser unfollowUser,
  }) : _fetchUserProfile = fetchUserProfile,
       _fetchUserPosts = fetchUserPosts,
       _currentUserCubit = currentUserCubit,
       _followUser = followUser,
       _unfollowUser = unfollowUser,
       super(ProfileInitial()) {
    on<ProfileFetchRequested>(_onFetchRequested);
    on<ProfileFollowToggleRequested>(_onFollowToggleRequested);
    on<ProfileRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onFetchRequested(
    ProfileFetchRequested event,
    Emitter<ProfileState> emit,
  ) async {
    await _loadProfileData(
      userId: event.userId,
      showFullScreenLoader: true,
      emit: emit,
    );
  }

  Future<void> _onRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    await _loadProfileData(
      userId: event.userId,
      showFullScreenLoader: false,
      emit: emit,
    );
  }

  Future<void> _loadProfileData({
    required String? userId,
    required bool showFullScreenLoader,
    required Emitter<ProfileState> emit,
  }) async {
    // 1. Safe extraction of your logged-in ID from core session state
    String? currentLoggedInId;
    final currentUserState = _currentUserCubit.state;
    if (currentUserState is CurrentUserLoggedIn) {
      currentLoggedInId = currentUserState.user.id;
    }

    // 2. Resolve the final target ID (fallback to current user if parameter is null)
    final String? targetUserId = userId ?? currentLoggedInId;

    // Safeguard gate check
    if (targetUserId == null) {
      emit(
        const ProfileLoadFailure(errorMessage: 'No active user session found.'),
      );
      return;
    }

    // 3. Assign to a strict, non-nullable String variable to satisfy UseCase requirements
    final String nonNullUserId = targetUserId;

    // 4. Perform the identity boundary comparison securely
    final bool calculatedIsMe = nonNullUserId == currentLoggedInId;

    // 5. Execute both queries
    final results = await Future.wait([
      _fetchUserProfile(nonNullUserId),
      _fetchUserPosts(nonNullUserId),
    ]);

    final profileResult = results[0] as Either<Failure, UserProfile>;
    final postsResult = results[1] as Either<Failure, List<Post>>;

    // Combine the results safely into success state
    profileResult.fold(
      (failure) => emit(ProfileLoadFailure(errorMessage: failure.message)),
      (profile) {
        postsResult.fold(
          (failure) => emit(ProfileLoadFailure(errorMessage: failure.message)),
          (posts) => emit(
            ProfileLoadSuccess(
              profile: profile,
              posts: posts,
              isMe: calculatedIsMe,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onFollowToggleRequested(
    ProfileFollowToggleRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // We can only alter values if the current layout is already loaded successfully
    if (state is! ProfileLoadSuccess) return;

    final currentState = state as ProfileLoadSuccess;
    final previousProfile = currentState.profile;

    // 1. Unpack current state metrics
    final bool wasFollowing = previousProfile.isFollowing;
    final int dynamicFollowersCount = wasFollowing
        ? previousProfile.followersCount - 1
        : previousProfile.followersCount + 1;

    // 2. Perform optimistic copy mutation
    final updatedProfile = previousProfile.copyWith(
      isFollowing: !wasFollowing,
      followersCount: dynamicFollowersCount,
    );

    // 3. Instantly emit the updated layout state so UI shifts with zero-latency
    emit(currentState.copyWith(profile: updatedProfile));

    // 4. Fire explicit execution downstream to the data repository layers
    final Either<Failure, Unit> result;
    if (wasFollowing) {
      result = await _unfollowUser(event.targetUserId);
    } else {
      result = await _followUser(event.targetUserId);
    }

    // 5. Evaluate backend persistence transaction response
    result.fold(
      (failure) {
        // ❌ Rollback: Revert to previous valid profile snapshot data on error
        emit(currentState.copyWith(profile: previousProfile));

        // Optional: You could append an error message field to your state to trigger a SnackBar
      },
      (_) {
        //  Success: Do nothing! The UI is already correct.
      },
    );
  }
}
