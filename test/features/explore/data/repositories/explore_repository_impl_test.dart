import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/exceptions.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/features/explore/data/datasources/explore_remote_data_source.dart';
import 'package:yemengram/features/explore/data/repositories/explore_repository_impl.dart';

// Pure structural contract mock bypassing heavy framework plugins.
class MockExploreRemoteDataSource extends Mock
    implements ExploreRemoteDataSource {}

class MockPost extends Mock implements Post {}

void main() {
  late ExploreRepositoryImpl repository;
  late MockExploreRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockExploreRemoteDataSource();
    repository = ExploreRepositoryImpl(mockRemoteDataSource);
  });

  final tPostsList = [MockPost(), MockPost()];
  const tExceptionMessage = 'Network Timeout Exception';

  group('getAllPosts', () {
    test(
      'should return Right containing list of posts when data source executes successfully',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getAllPosts(),
        ).thenAnswer((_) async => tPostsList);

        // Act
        final result = await repository.getAllPosts();

        // Assert
        expect(result, equals(Right<Failure, List<Post>>(tPostsList)));
        verify(() => mockRemoteDataSource.getAllPosts()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return Left containing ServerFailure when data source throws a ServerException',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getAllPosts(),
        ).thenThrow(const ServerException(tExceptionMessage));

        // Act
        final result = await repository.getAllPosts();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, equals(tExceptionMessage));
          },
          (_) => fail(
            'Expected Left side return but received Right side instead.',
          ),
        );
        verify(() => mockRemoteDataSource.getAllPosts()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return Left containing ServerFailure when data source throws an unhandled generic error',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getAllPosts(),
        ).thenThrow(Exception('Unknown system fault'));

        // Act
        final result = await repository.getAllPosts();

        // Assert
        expect(result, isA<Left<Failure, List<Post>>>());
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Should have returned a Left'),
        );
        verify(() => mockRemoteDataSource.getAllPosts()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
