/// Internal exception thrown within the data layer during remote service or API failures.
///
/// Should be caught by repositories and mapped to a [ServerFailure].
class ServerException implements Exception {
  /// The technical error message from the backend or server.
  final String message;

  /// Creates a server exception wrapper.
  const ServerException(this.message);
}

/// Internal exception thrown within the data layer during local key-value storage operations.
///
/// Should be caught by repositories and mapped to a [CacheFailure].
class CacheException implements Exception {
  /// The technical error message from the local device storage.
  final String message;

  /// Creates a cache exception wrapper.
  const CacheException([
    this.message = 'A local storage cache error occurred.',
  ]);
}
