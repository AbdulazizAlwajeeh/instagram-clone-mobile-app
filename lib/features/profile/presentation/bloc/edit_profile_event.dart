sealed class EditProfileEvent {
  const EditProfileEvent();
}

/// Dispatched interactively as the user types a new username into the entry field.
class EditProfileUsernameChanged extends EditProfileEvent {
  final String username;

  const EditProfileUsernameChanged({required this.username});
}

/// Dispatched when the user submits the form to save profile alterations.
class EditProfileSubmitted extends EditProfileEvent {
  final String? username;
  final String? fullName;
  final String? bio;
  final dynamic imageFile;

  const EditProfileSubmitted({
    this.username,
    this.fullName,
    this.bio,
    this.imageFile,
  });
}
