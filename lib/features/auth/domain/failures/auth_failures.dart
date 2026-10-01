import '../../../../core/error/failures.dart';

/// Returned when the email and password combination do not match any account.
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super();
}

/// Returned when a user tries to sign up with an email that is already registered.
class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super();
}

/// Returned when a user tries to sign up with a username that is already
/// registered.
class UsernameAlreadyInUseFailure extends AuthFailure {
  const UsernameAlreadyInUseFailure() : super();
}

/// Returned when the password does not meet security requirements.
class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super();
}

/// Returned when a network timeout or connection drop occurs during auth.
class AuthNetworkFailure extends AuthFailure {
  const AuthNetworkFailure() : super();
}
