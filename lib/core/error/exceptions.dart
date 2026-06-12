class ServerException implements Exception {
  final String message;

  const ServerException(this.message);
}

class CacheException implements Exception {
  final String message;

  const CacheException([
    this.message = 'A local storage cache error occurred.',
  ]);
}
