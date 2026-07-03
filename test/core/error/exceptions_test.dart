import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/core/error/exceptions.dart';

void main() {
  group('Exception Subclass Tests', () {
    test('ServerException should correctly set its technical message', () {
      const exception = ServerException('PostgrestException: 401 Unauthorized');
      expect(exception.message, 'PostgrestException: 401 Unauthorized');
    });

    test('CacheException should use default message when none is provided', () {
      const exception = CacheException();
      expect(exception.message, 'A local storage cache error occurred.');
    });

    test('CacheException should retain custom message when provided', () {
      const exception = CacheException('Secure storage read corruption.');
      expect(exception.message, 'Secure storage read corruption.');
    });
  });
}
