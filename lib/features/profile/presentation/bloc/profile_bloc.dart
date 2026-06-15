import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_user/presentation/cubit/current_user_cubit.dart';
import '../../domain/usecases/fetch_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FetchUserProfile _fetchUserProfile;
  final CurrentUserCubit _currentUserCubit;

  ProfileBloc({
    required FetchUserProfile fetchUserProfile,
    required CurrentUserCubit currentUserCubit,
  })  : _fetchUserProfile = fetchUserProfile,
        _currentUserCubit = currentUserCubit,
        super(ProfileInitial()) {
    on<ProfileFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
      ProfileFetchRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());

    // Evaluate identity boundary directly by reading core current state
    bool calculatedIsMe = false;
    final currentUserState = _currentUserCubit.state;
    if (currentUserState is CurrentUserLoggedIn) {
      calculatedIsMe = currentUserState.user.id == event.userId;
    }

    final result = await _fetchUserProfile(event.userId);

    result.fold(
          (failure) => emit(ProfileLoadFailure(errorMessage: failure.message)),
          (profile) => emit(ProfileLoadSuccess(
        profile: profile,
        isMe: calculatedIsMe,
      )),
    );
  }
}
