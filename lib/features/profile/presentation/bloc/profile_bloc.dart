import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
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

  ProfileBloc({
    required FetchUserProfile fetchUserProfile,
    required FetchUserPosts fetchUserPosts,
    required CurrentUserCubit currentUserCubit,
  }) : _fetchUserProfile = fetchUserProfile,
       _fetchUserPosts = fetchUserPosts,
       _currentUserCubit = currentUserCubit,
       super(ProfileInitial()) {
    on<ProfileFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    ProfileFetchRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    // 1. Safe extraction of your logged-in ID from core session state
    String? currentLoggedInId;
    final currentUserState = _currentUserCubit.state;
    if (currentUserState is CurrentUserLoggedIn) {
      currentLoggedInId = currentUserState.user.id;
    }

    // 2. Resolve the final target ID (fallback to current user if parameter is null)
    final String? targetUserId = event.userId ?? currentLoggedInId;

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
}
