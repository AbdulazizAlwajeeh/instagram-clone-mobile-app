part of 'current_user_cubit.dart';

sealed class CurrentUserState {
  const CurrentUserState();
}

/// Represents an unauthenticated session or an app during bootup.
class CurrentUserInitial extends CurrentUserState {
  const CurrentUserInitial();
}

/// Represents an active, verified user session.
class CurrentUserLoggedIn extends CurrentUserState {
  final AppUser user;

  const CurrentUserLoggedIn(this.user);
}
