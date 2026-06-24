import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/usecases/check_username_availability.dart';
import '../../domain/usecases/edit_profile.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfile _editProfile;
  final CheckUsernameAvailability _checkUsernameAvailability;

  EditProfileBloc({
    required EditProfile editProfile,
    required CheckUsernameAvailability checkUsernameAvailability,
  }) : _editProfile = editProfile,
       _checkUsernameAvailability = checkUsernameAvailability,
       super(EditProfileInitial()) {
    on<EditProfileSubmitted>(_onEditProfileSubmitted);
    on<EditProfileUsernameChanged>(
      _onUsernameChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onUsernameChanged(
    EditProfileUsernameChanged event,
    Emitter<EditProfileState> emit,
  ) async {
    if (event.username.trim().isEmpty) {
      emit(EditProfileInitial());
      return;
    }

    await _verifyUsername(username: event.username.trim(), emit: emit);
  }

  Future<void> _onEditProfileSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    await _updateProfileData(
      username: event.username,
      fullName: event.fullName,
      bio: event.bio,
      imageFile: event.imageFile,
      emit: emit,
    );
  }

  Future<void> _verifyUsername({
    required String username,
    required Emitter<EditProfileState> emit,
  }) async {
    emit(EditProfileUsernameChecking());

    final result = await _checkUsernameAvailability(username);

    result.fold(
      (failure) => emit(EditProfileFailure(errorMessage: failure.message)),
      (isAvailable) => emit(
        isAvailable
            ? EditProfileUsernameAvailable()
            : EditProfileUsernameTaken(),
      ),
    );
  }

  Future<void> _updateProfileData({
    String? username,
    String? fullName,
    String? bio,
    dynamic imageFile,
    required Emitter<EditProfileState> emit,
  }) async {
    emit(EditProfileSubmitting());

    final result = await _editProfile(
      EditProfileParams(
        username: username,
        fullName: fullName,
        bio: bio,
        imageFile: imageFile,
      ),
    );

    result.fold(
      (failure) => emit(EditProfileFailure(errorMessage: failure.message)),
      (_) => emit(EditProfileSuccess()),
    );
  }
}
