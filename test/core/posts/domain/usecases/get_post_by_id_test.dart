import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/core/posts/domain/repositories/post_detail_repository.dart';
import 'package:yemengram/core/posts/domain/usecases/get_post_by_id.dart';

// Create a mock class implementing the repository interface contract
class MockPostDetailRepository extends Mock implements PostDetailRepository {}

void main() {
  late GetPostById useCase;
  late MockPostDetailRepository mockRepository;

  // Runs before every individual test to guarantee a fresh slate
  setUp(() {
    mockRepository = MockPostDetailRepository();
    useCase = GetPostById(mockRepository);
  });

  const tPostId = 'post_123';

  // Dummy post instance used for successful response configurations
  final tPost = Post(
    id: tPostId,
    author: const AppUser(id: '1', email: 'e', username: 'u'),
    mediaUrl: 'https://example.com',
    likesCount: 0,
    commentsCount: 0,
    createdAt: DateTime.now(),
    isLiked: false,
  );

  group('GetPostById UseCase Tests', () {
    test(
      'should return Right(Post) from repository on a successful fetch cycle',
      () async {
        // Arrange
        when(
          () => mockRepository.getPostById(tPostId),
        ).thenAnswer((_) async => Right(tPost));

        // Act
        final result = await useCase(tPostId);

        // Assert
        expect(result, Right(tPost));

        // Verify that the repository method was actually called exactly once
        verify(() => mockRepository.getPostById(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left(ServerFailure) from repository when operational call fails',
      () async {
        // Arrange
        const tFailure = ServerFailure('Database timeout error');
        when(
          () => mockRepository.getPostById(tPostId),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tPostId);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.getPostById(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
