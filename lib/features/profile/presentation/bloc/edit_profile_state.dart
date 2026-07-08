/// Sealed base class representing all possible states for the profile modification screen.
sealed class EditProfileState {
  /// Base constant constructor for all profile modification states.
  const EditProfileState();
}

/// Initial state of the state machine upon structural instantiation.
class EditProfileInitial extends EditProfileState {}

/// State emitted while the system asynchronously checks username availability.
class EditProfileUsernameChecking extends EditProfileState {}

/// State emitted when the interactively checked username is available for claim.
class EditProfileUsernameAvailable extends EditProfileState {}

/// State emitted when the interactively checked username is already taken.
class EditProfileUsernameTaken extends EditProfileState {}

/// State emitted while the profile alteration payload is being saved to the server.
class EditProfileSubmitting extends EditProfileState {}

/// State emitted upon successful execution of the profile update operation.
class EditProfileSuccess extends EditProfileState {}

/// State emitted when an error occurs during profile modification routines.
class EditProfileFailure extends EditProfileState {
  /// The user-facing error message describing the validation or transaction failure.
  final String errorMessage;

  /// Creates an [EditProfileFailure] state with the required error description.
  const EditProfileFailure({required this.errorMessage});
}
