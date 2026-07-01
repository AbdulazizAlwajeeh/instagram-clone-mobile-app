/// Represents the core authenticated user entity across the application.
///
/// This class is located in the core layer because it serves as the shared
/// data model required by multiple features for identity and personalization.
class AppUser {
  /// The unique identifier for the user.
  final String id;

  /// The primary email address associated with the user account.
  final String email;

  /// The unique display name chosen by the user.
  final String username;

  /// The optional remote URL pointing to the user's profile image.
  ///
  /// This value can be `null` if the user has not set an avatar.
  final String? avatarUrl;

  /// Creates an immutable instance of [AppUser].
  const AppUser({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
  });
}
