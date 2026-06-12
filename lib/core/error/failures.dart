abstract class Failure {
  final String message;

  const Failure([this.message = 'An unexpected error occurred.']);
}

// Catches Supabase network/database rejections globally
class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

// Catches session timeouts, missing tokens, and invalid auth states globally
class AuthFailure extends Failure {
  const AuthFailure([super.message]);
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Local storage caching operation failed.',
  ]);
}
