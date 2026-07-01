part of 'current_user_cubit.dart';

/// Base state class for tracking global user authentication status.
///
/// Subclasses define whether a user session is active or unauthenticated.
sealed class CurrentUserState {
  /// Abstract constant constructor for state immutability.
  const CurrentUserState();
}

/// Represents an unauthenticated session or an app during bootup.
class CurrentUserInitial extends CurrentUserState {
  /// Creates the initial unauthenticated state.
  const CurrentUserInitial();
}

/// Represents an active, verified user session.
class CurrentUserLoggedIn extends CurrentUserState {
  /// The core user entity containing identity details.
  final AppUser user;

  /// Creates a logged-in state wrapped with the current [user] data.
  const CurrentUserLoggedIn(this.user);
}
