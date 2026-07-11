import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/error/exceptions.dart';
import 'package:yemengram/core/posts/data/datasoucres/post_detail_remote_data_source.dart';
import 'package:yemengram/core/posts/data/models/comment_model.dart';
import 'package:yemengram/core/posts/data/models/post_model.dart';
import 'package:yemengram/core/posts/data/repositories/post_detail_repository_impl.dart';

// Create a mock class implementing the low-level remote data source interface
class MockPostDetailRemoteDataSource extends Mock
    implements PostDetailRemoteDataSource {}

void main() {
  late PostDetailRepositoryImpl repository;
  late MockPostDetailRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockPostDetailRemoteDataSource();
    repository = PostDetailRepositoryImpl(mockRemoteDataSource);
  });

  const tPostId = 'post_123';

  final tPostModel = PostModel(
    id: tPostId,
    author: const AppUser(id: '1', email: 'e', username: 'u'),
    mediaUrl: 'https://example.com',
    likesCount: 0,
    commentsCount: 0,
    createdAt: DateTime.now(),
    isLiked: false,
    reportedByMe: false,
  );

  final tCommentModels = [
    const CommentModel(
      id: 'c_1',
      postId: tPostId,
      userId: 'u_1',
      username: 'yemen_user',
      avatarUrl: '',
      text: 'Beautiful architecture',
      createdAt: '2026-06-30T12:00:00Z',
    ),
  ];

  group('PostDetailRepositoryImpl Tests', () {
    group('getPostById execution routing', () {
      test(
        'should return Right(Post) when the remote data source query completes successfully',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPostById(tPostId),
          ).thenAnswer((_) async => tPostModel);

          // Act
          final result = await repository.getPostById(tPostId);

          // Assert
          expect(result, Right(tPostModel));
          verify(() => mockRemoteDataSource.getPostById(tPostId)).called(1);
        },
      );

      test(
        'should catch ServerException and map it to Left(ServerFailure) on backend failures',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPostById(tPostId),
          ).thenThrow(const ServerException('Database lookup rejected'));

          // Act
          final result = await repository.getPostById(tPostId);

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure.message, 'Database lookup rejected'),
            (_) => fail('Should not return Right data on exception rejections'),
          );
          verify(() => mockRemoteDataSource.getPostById(tPostId)).called(1);
        },
      );

      test(
        'should catch unexpected generic exceptions and return Left(ServerFailure) containing the raw string text description',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPostById(tPostId),
          ).thenThrow(Exception('No internet connection available'));

          // Act
          final result = await repository.getPostById(tPostId);

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(
              failure.message,
              'Exception: No internet connection available',
            ),
            (_) => fail(
              'Should not return Right data on generic exception crashes',
            ),
          );
          verify(() => mockRemoteDataSource.getPostById(tPostId)).called(1);
        },
      );
    });

    group('toggleLikePost execution routing', () {
      test(
        'should return Right(unit) when remote toggle operation succeeds',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.toggleLikePost(tPostId),
          ).thenAnswer((_) async => Future<void>.value());

          // Act
          final result = await repository.toggleLikePost(tPostId);

          // Assert
          expect(result, const Right(unit));
          verify(() => mockRemoteDataSource.toggleLikePost(tPostId)).called(1);
        },
      );

      test(
        'should catch ServerException and turn it into Left(ServerFailure) on database execution error timelines',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.toggleLikePost(tPostId),
          ).thenThrow(const ServerException('Unauthorized action'));

          // Act
          final result = await repository.toggleLikePost(tPostId);

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure.message, 'Unauthorized action'),
            (_) => fail(
              'Should not return Right unit tracking parameters on failure states',
            ),
          );
          verify(() => mockRemoteDataSource.toggleLikePost(tPostId)).called(1);
        },
      );
    });
    group('getPostComments execution routing', () {
      test(
        'should return Right(List<Comment>) when remote comment data fetch succeeds',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPostComments(tPostId),
          ).thenAnswer((_) async => tCommentModels);

          // Act
          final result = await repository.getPostComments(tPostId);

          // Assert
          expect(result.isRight(), isTrue);
          result.fold(
            (_) => fail('Should not fail'),
            (comments) => expect(comments, tCommentModels),
          );
          verify(() => mockRemoteDataSource.getPostComments(tPostId)).called(1);
        },
      );

      test(
        'should catch ServerException and map to Left(ServerFailure) when loading comments fails',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPostComments(tPostId),
          ).thenThrow(const ServerException('Comments stream broke'));

          // Act
          final result = await repository.getPostComments(tPostId);

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure.message, 'Comments stream broke'),
            (_) => fail('Should fail'),
          );
          verify(() => mockRemoteDataSource.getPostComments(tPostId)).called(1);
        },
      );
    });

    group('addComment execution routing', () {
      const tText = 'Awesome project style!';

      test(
        'should return Right(unit) when remote comment injection insertion succeeds',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.addComment(postId: tPostId, text: tText),
          ).thenAnswer((_) async => Future<void>.value());

          // Act
          final result = await repository.addComment(
            postId: tPostId,
            text: tText,
          );

          // Assert
          expect(result, const Right(unit));
          verify(
            () => mockRemoteDataSource.addComment(postId: tPostId, text: tText),
          ).called(1);
        },
      );

      test(
        'should catch ServerException and return Left(ServerFailure) on comment persistence failures',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.addComment(postId: tPostId, text: tText),
          ).thenThrow(const ServerException('Profanity filter rejection'));

          // Act
          final result = await repository.addComment(
            postId: tPostId,
            text: tText,
          );

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure.message, 'Profanity filter rejection'),
            (_) => fail('Should fail'),
          );
          verify(
            () => mockRemoteDataSource.addComment(postId: tPostId, text: tText),
          ).called(1);
        },
      );
    });
  });

  group('reportPost execution routing', () {
    test(
      'should return Right(unit) when remote report operation completes successfully',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.reportPost(postId: tPostId),
        ).thenAnswer((_) async => Future<void>.value());

        // Act
        final result = await repository.reportPost(postId: tPostId);

        // Assert
        expect(result, const Right(unit));
        verify(
          () => mockRemoteDataSource.reportPost(postId: tPostId),
        ).called(1);
      },
    );

    test(
      'should catch ServerException and map it to Left(ServerFailure) on backend reporting failures',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.reportPost(postId: tPostId),
        ).thenThrow(const ServerException('Post already reported'));

        // Act
        final result = await repository.reportPost(postId: tPostId);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure.message, 'Post already reported'),
          (_) =>
              fail('Should not return Right unit data on exception rejections'),
        );
        verify(
          () => mockRemoteDataSource.reportPost(postId: tPostId),
        ).called(1);
      },
    );

    test(
      'should catch unexpected generic exceptions and return Left(ServerFailure) containing the raw string text description',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.reportPost(postId: tPostId),
        ).thenThrow(Exception('Timeout connection error'));

        // Act
        final result = await repository.reportPost(postId: tPostId);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) =>
              expect(failure.message, 'Exception: Timeout connection error'),
          (_) =>
              fail('Should not return Right data on generic exception crashes'),
        );
        verify(
          () => mockRemoteDataSource.reportPost(postId: tPostId),
        ).called(1);
      },
    );
  });
}
