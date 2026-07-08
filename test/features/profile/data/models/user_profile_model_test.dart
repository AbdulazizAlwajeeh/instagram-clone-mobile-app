import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/features/profile/data/models/user_profile_model.dart';
import 'package:yemengram/features/profile/domain/entities/user_profile.dart';

void main() {
  final tJson = {
    'id': 'user_abc',
    'username': 'johndoe',
    'full_name': 'John Doe',
    'avatar_url': 'https://example.com',
    'bio': 'Developer bio',
    'posts_count': 12,
    'followers_count': 150,
    'following_count': 85,
  };

  test('should be a subclass of UserProfile entity', () {
    const model = UserProfileModel(
      id: 'user_abc',
      username: 'johndoe',
      fullName: 'John Doe',
      postsCount: 12,
      followersCount: 150,
      followingCount: 85,
      isFollowing: true,
    );

    expect(model, isA<UserProfile>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when JSON fields are fully populated',
      () {
        final result = UserProfileModel.fromJson(tJson, isFollowing: true);

        expect(result.id, 'user_abc');
        expect(result.username, 'johndoe');
        expect(result.fullName, 'John Doe');
        expect(result.avatarUrl, 'https://example.com');
        expect(result.bio, 'Developer bio');
        expect(result.postsCount, 12);
        expect(result.followersCount, 150);
        expect(result.followingCount, 85);
        expect(result.isFollowing, isTrue);
      },
    );

    test(
      'should return a valid model with fallback defaults when parsing nullable missing values',
      () {
        final emptyJson = {
          'id': 'user_empty',
          'username': null,
          'full_name': null,
          'avatar_url': null,
          'bio': null,
          'posts_count': null,
          'followers_count': null,
          'following_count': null,
        };

        final result = UserProfileModel.fromJson(emptyJson, isFollowing: false);

        expect(result.id, 'user_empty');
        expect(result.username, '');
        expect(result.fullName, '');
        expect(result.avatarUrl, isNull);
        expect(result.bio, isNull);
        expect(result.postsCount, 0);
        expect(result.followersCount, 0);
        expect(result.followingCount, 0);
        expect(result.isFollowing, isFalse);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the accurate object schema attributes',
      () {
        final model = UserProfileModel.fromJson(tJson, isFollowing: false);
        final result = model.toJson();

        expect(result['id'], tJson['id']);
        expect(result['username'], tJson['username']);
        expect(result['full_name'], tJson['full_name']);
        expect(result['avatar_url'], tJson['avatar_url']);
        expect(result['bio'], tJson['bio']);
        expect(result['posts_count'], tJson['posts_count']);
        expect(result['followers_count'], tJson['followers_count']);
        expect(result['following_count'], tJson['following_count']);
        expect(
          result.containsKey('is_following'),
          isFalse,
        ); // context parameter excluded from table column schema
      },
    );
  });
}
