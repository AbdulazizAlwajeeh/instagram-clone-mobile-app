import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/features/profile/domain/entities/user_profile.dart';

void main() {
  const tProfile = UserProfile(
    id: 'user_123',
    username: 'coder',
    fullName: 'Jane Coder',
    avatarUrl: 'https://example.com',
    bio: 'Flutter Dev',
    postsCount: 5,
    followersCount: 100,
    followingCount: 50,
    isFollowing: true,
  );

  group('UserProfile Entity', () {
    test(
      'should instantiate immutable values correctly through constructor fields',
      () {
        expect(tProfile.id, 'user_123');
        expect(tProfile.username, 'coder');
        expect(tProfile.fullName, 'Jane Coder');
        expect(tProfile.avatarUrl, 'https://example.com');
        expect(tProfile.bio, 'Flutter Dev');
        expect(tProfile.postsCount, 5);
        expect(tProfile.followersCount, 100);
        expect(tProfile.followingCount, 50);
        expect(tProfile.isFollowing, isTrue);
      },
    );

    group('copyWith', () {
      test(
        'should yield an identical object instance structure when zero parameters are provided',
        () {
          final replica = tProfile.copyWith();

          expect(replica.id, tProfile.id);
          expect(replica.username, tProfile.username);
          expect(replica.fullName, tProfile.fullName);
          expect(replica.avatarUrl, tProfile.avatarUrl);
          expect(replica.bio, tProfile.bio);
          expect(replica.postsCount, tProfile.postsCount);
          expect(replica.followersCount, tProfile.followersCount);
          expect(replica.followingCount, tProfile.followingCount);
          expect(replica.isFollowing, tProfile.isFollowing);
        },
      );

      test(
        'should yield an updated object instance structure overriding only specified fields',
        () {
          final updated = tProfile.copyWith(
            username: 'hacker',
            postsCount: 6,
            isFollowing: false,
          );

          // Overridden traits verify distinct values
          expect(updated.username, 'hacker');
          expect(updated.postsCount, 6);
          expect(updated.isFollowing, isFalse);

          // Untouched traits retain baseline properties
          expect(updated.id, tProfile.id);
          expect(updated.fullName, tProfile.fullName);
          expect(updated.avatarUrl, tProfile.avatarUrl);
          expect(updated.bio, tProfile.bio);
          expect(updated.followersCount, tProfile.followersCount);
          expect(updated.followingCount, tProfile.followingCount);
        },
      );
    });
  });
}
