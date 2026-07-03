import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/auth/data/models/app_user_model.dart';

void main() {
  const tId = 'user_123';
  const tEmail = 'test@example.com';
  const tUsername = 'dev_user';
  const tAvatarUrl = 'https://example.com';

  const tAppUserModel = AppUserModel(
    id: tId,
    email: tEmail,
    username: tUsername,
    avatarUrl: tAvatarUrl,
  );

  group('AppUserModel', () {
    test('should be a subclass of AppUser entity', () {
      expect(tAppUserModel, isA<AppUser>());
    });

    group('fromJson', () {
      test('should return a valid model from a standard database JSON map', () {
        final Map<String, dynamic> jsonMap = {
          'id': tId,
          'email': tEmail,
          'username': tUsername,
          'avatar_url': tAvatarUrl,
        };

        final result = AppUserModel.fromJson(jsonMap);

        expect(result, isA<AppUser>());
        expect(result.id, tId);
        expect(result.email, tEmail);
        expect(result.username, tUsername);
        expect(result.avatarUrl, tAvatarUrl);
      });

      test(
        'should extract username from user_metadata fallback map when top-tier key is missing',
        () {
          final Map<String, dynamic> jsonMap = {
            'id': tId,
            'email': tEmail,
            'user_metadata': {'username': tUsername},
            'avatar_url': tAvatarUrl,
          };

          final result = AppUserModel.fromJson(jsonMap);

          expect(result.username, tUsername);
        },
      );

      test(
        'should return fallback empty strings when critical fields are missing or null',
        () {
          final Map<String, dynamic> jsonMap = {};

          final result = AppUserModel.fromJson(jsonMap);

          expect(result.id, '');
          expect(result.email, '');
          expect(result.username, '');
          expect(result.avatarUrl, isNull);
        },
      );
    });

    group('toJson', () {
      test('should return a JSON map containing the proper model data', () {
        final result = tAppUserModel.toJson();

        final expectedMap = {
          'id': tId,
          'email': tEmail,
          'username': tUsername,
          'avatar_url': tAvatarUrl,
        };

        expect(result, equals(expectedMap));
      });
    });
  });
}
