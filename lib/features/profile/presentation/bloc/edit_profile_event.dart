/// Sealed base class representing all incoming events to the profile modification business logic component.
sealed class EditProfileEvent {
  /// Base constant constructor for all edit profile events.
  const EditProfileEvent();
}

/// Dispatched interactively as the user types a new username into the entry field.
class EditProfileUsernameChanged extends EditProfileEvent {
  /// The current username string typed into the input field.
  final String username;

  /// Creates an [EditProfileUsernameChanged] event with the given [username].
  const EditProfileUsernameChanged({required this.username});
}

/// Dispatched when the user submits the form to save profile alterations.
class EditProfileSubmitted extends EditProfileEvent {
  /// The newly requested unique username handle.
  final String? username;

  /// The updated public display name.
  final String? fullName;

  /// The revised biographical description.
  final String? bio;

  /// The raw image file object intended for avatar upload.
  final dynamic imageFile;

  /// Constructs an immutable event capturing form fields for submission.
  const EditProfileSubmitted({
    this.username,
    this.fullName,
    this.bio,
    this.imageFile,
  });
}
