import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';

void main() {
  // A group bundles related tests together for clean test reporting
  group('AppUser Entity Tests', () {
    test('should instantiate correctly with all required properties', () {
      // Arrange & Act
      const user = AppUser(
        id: 'user_123',
        email: 'test@example.com',
        username: 'yemen_dev',
        avatarUrl: 'https://example.com',
      );

      // Assert
      expect(user.id, 'user_123');
      expect(user.email, 'test@example.com');
      expect(user.username, 'yemen_dev');
      expect(user.avatarUrl, 'https://example.com');
    });

    test('should support null values for optional avatarUrl property', () {
      // Arrange & Act
      const user = AppUser(
        id: 'user_456',
        email: 'null_avatar@example.com',
        username: 'clean_coder',
        avatarUrl: null, // Testing the null safety of the entity
      );

      // Assert
      expect(user.avatarUrl, isNull);
    });
  });
}
