import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/features/feed/domain/repositories/feed_repository.dart';
import 'package:yemengram/features/feed/domain/usecases/get_followed_users_posts.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

class MockPost extends Mock implements Post {}

void main() {
  late GetFollowedUsersPosts useCase;
  late MockFeedRepository mockFeedRepository;

  setUp(() {
    mockFeedRepository = MockFeedRepository();
    useCase = GetFollowedUsersPosts(mockFeedRepository);
  });

  const tUserId = 'user-id-54321';
  const tLimit = 10;
  final tTimestamp = DateTime.parse('2026-07-05T00:00:00Z');
  final tPostsList = [MockPost(), MockPost()];
  const tFailureMessage = 'Timeline stream synchronization failed';

  group('GetFollowedUsersPosts UseCase', () {
    test(
      'should forward parameters to the repository and return Right list of timeline posts on success',
      () async {
        // Arrange
        when(
          () => mockFeedRepository.getFollowedUsersPosts(
            userId: any(named: 'userId', that: isA<String>()),
            limit: any(named: 'limit', that: isA<int>()),
            lastPostTimestamp: any(named: 'lastPostTimestamp'),
          ),
        ).thenAnswer((_) async => Right(tPostsList));

        final params = GetFollowedUsersPostsParams(
          userId: tUserId,
          limit: tLimit,
          lastPostTimestamp: tTimestamp,
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(Right<Failure, List<Post>>(tPostsList)));
        verify(
          () => mockFeedRepository.getFollowedUsersPosts(
            userId: tUserId,
            limit: tLimit,
            lastPostTimestamp: tTimestamp,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockFeedRepository);
      },
    );

    test(
      'should return Left containing ServerFailure when the repository layer transaction rejects requests',
      () async {
        // Arrange
        when(
          () => mockFeedRepository.getFollowedUsersPosts(
            userId: any(named: 'userId', that: isA<String>()),
            limit: any(named: 'limit', that: isA<int>()),
            lastPostTimestamp: any(named: 'lastPostTimestamp'),
          ),
        ).thenAnswer((_) async => const Left(ServerFailure(tFailureMessage)));

        final params = GetFollowedUsersPostsParams(userId: tUserId);

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, equals(tFailureMessage));
          },
          (_) => fail('Expected Left side return but received Right instead.'),
        );
        verify(
          () => mockFeedRepository.getFollowedUsersPosts(
            userId: tUserId,
            limit: 10, // Uses fallback default initialization criteria
            lastPostTimestamp: null,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockFeedRepository);
      },
    );
  });
}
