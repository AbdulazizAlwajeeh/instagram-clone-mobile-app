/// Base class representing all application failures that propagate up to the presentation layer.
///
/// Designed to convert exceptions into user-friendly error messages displayed in the UI.
abstract class Failure {
  /// The user-facing error message describing the failure.
  final String message;

  /// Creates a [Failure] with an optional descriptive message.
  const Failure([this.message = 'An unexpected error occurred.']);
}

/// Catches Supabase network, database, or server rejections globally.
class ServerFailure extends Failure {
  /// Creates a server-related failure instance.
  const ServerFailure([super.message]);
}

/// Catches session timeouts, missing tokens, and invalid authentication states globally.
class AuthFailure extends Failure {
  /// Creates an authentication-related failure instance.
  const AuthFailure([super.message]);
}

/// Catches local data persistence, hydration, or storage driver errors.
class CacheFailure extends Failure {
  /// Creates a caching-related failure instance with a default fallback message.
  const CacheFailure([
    super.message = 'Local storage caching operation failed.',
  ]);
}
