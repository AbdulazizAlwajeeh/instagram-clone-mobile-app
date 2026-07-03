import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/core/error/failures.dart';

void main() {
  group('Failure Subclass Tests', () {
    test('ServerFailure should fallback to default message if none is provided', () {
      const failure = ServerFailure();
      expect(failure.message, 'An unexpected error occurred.');
    });

    test('ServerFailure should retain custom message when provided', () {
      const failure = ServerFailure('Supabase connection lost.');
      expect(failure.message, 'Supabase connection lost.');
    });

    test('AuthFailure should fallback to default message if none is provided', () {
      const failure = AuthFailure();
      expect(failure.message, 'An unexpected error occurred.');
    });

    test('AuthFailure should retain custom message when provided', () {
      const failure = AuthFailure('Invalid credentials.');
      expect(failure.message, 'Invalid credentials.');
    });

    test('CacheFailure should use its own specific default message if none is provided', () {
      const failure = CacheFailure();
      expect(failure.message, 'Local storage caching operation failed.');
    });

    test('CacheFailure should retain custom message when provided', () {
      const failure = CacheFailure('Hive box failed to open.');
      expect(failure.message, 'Hive box failed to open.');
    });
  });
}
