import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/exceptions.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/data/models/post_model.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:yemengram/features/feed/data/repositories/feed_repository_impl.dart';

class MockFeedRemoteDataSource extends Mock implements FeedRemoteDataSource {}

class MockPostModel extends Mock implements PostModel {}

void main() {
  late FeedRepositoryImpl repository;
  late MockFeedRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockFeedRemoteDataSource();
    repository = FeedRepositoryImpl(mockRemoteDataSource);
  });

  const tUserId = 'user-xyz';
  const tLimit = 15;
  final tTimestamp = DateTime.parse('2026-07-05T12:00:00Z');
  final tPostModelsList = [MockPostModel(), MockPostModel()];
  const tErrorMessage = 'Database fetch rejected';

  group('getFollowedUsersPosts', () {
    test(
      'should return Right containing mapped list of posts when remote execution succeeds',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getFollowedUsersPostsRaw(
            userId: any(named: 'userId', that: isA<String>()),
            limit: any(named: 'limit', that: isA<int>()),
            lastPostTimestamp: any(named: 'lastPostTimestamp'),
          ),
        ).thenAnswer((_) async => tPostModelsList);

        // Act
        final result = await repository.getFollowedUsersPosts(
          userId: tUserId,
          limit: tLimit,
          lastPostTimestamp: tTimestamp,
        );

        // Assert
        expect(result, isA<Right<Failure, List<Post>>>());
        result.fold(
          (_) => fail('Should have returned a Right collection'),
          (posts) => expect(posts, equals(tPostModelsList)),
        );
        verify(
          () => mockRemoteDataSource.getFollowedUsersPostsRaw(
            userId: tUserId,
            limit: tLimit,
            lastPostTimestamp: tTimestamp,
          ),
        ).called(1);
      },
    );

    test(
      'should return Left containing ServerFailure when remote data source throws a ServerException',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getFollowedUsersPostsRaw(
            userId: any(named: 'userId', that: isA<String>()),
            limit: any(named: 'limit', that: isA<int>()),
            lastPostTimestamp: any(named: 'lastPostTimestamp'),
          ),
        ).thenThrow(const ServerException(tErrorMessage));

        // Act
        final result = await repository.getFollowedUsersPosts(
          userId: tUserId,
          limit: tLimit,
          lastPostTimestamp: tTimestamp,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            // Explicitly assert properties to verify structural equivalence
            expect(failure.message, equals(tErrorMessage));
          },
          (_) => fail('Expected Left side return but received Right instead.'),
        );
      },
    );
  });
}
