import '../../../../core/error/failures.dart';
import '../../domain/failures/auth_failures.dart';

extension AuthFailureMessage on Failure {
  /// Transforms strongly-typed domain failures into human-readable UI strings.
  String toUserMessage() {
    return switch (this) {
      // Handle specific authentication failure classes
      InvalidCredentialsFailure() =>
        'Incorrect email/password.',

      EmailAlreadyInUseFailure() =>
        'This email is either already reserved or needs confirmation, check '
            'your inbox.',

      UsernameAlreadyInUseFailure() =>
        'This username is already reserved.',

      WeakPasswordFailure() =>
        'This password is too weak.',

      AuthNetworkFailure() =>
        'Connection timed out. Please check your internet and try again.',

      // Handle core global failures
      ServerFailure() =>
        'Our servers are experiencing issues. Please try again later.',

      CacheFailure() =>
        'Could not load your local session data. Please log in again.',

      // Fallback for generic AuthFailure or unhandled runtime exceptions
      _ => 'An unexpected error occurred. Please try again.',
    };
  }
}
