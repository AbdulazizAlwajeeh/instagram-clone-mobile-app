import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/entities/comment.dart';
import 'package:yemengram/core/posts/domain/repositories/post_detail_repository.dart';
import 'package:yemengram/core/posts/domain/usecases/get_post_comments.dart';

class MockPostDetailRepository extends Mock implements PostDetailRepository {}

void main() {
  late GetPostComments useCase;
  late MockPostDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockPostDetailRepository();
    useCase = GetPostComments(mockRepository);
  });

  const tPostId = 'post_123';

  final tCommentsList = [
    const Comment(
      id: 'c_1',
      postId: tPostId,
      userId: 'u_1',
      username: 'user_one',
      avatarUrl: '',
      text: 'Great post!',
      createdAt: '2026-06-30T12:00:00Z',
    ),
  ];

  group('GetPostComments UseCase Tests', () {
    test(
      'should return Right(List<Comment>) from repository on a successful load query',
      () async {
        // Arrange
        when(
          () => mockRepository.getPostComments(tPostId),
        ).thenAnswer((_) async => Right(tCommentsList));

        // Act
        final result = await useCase(tPostId);

        // Assert
        expect(result, Right(tCommentsList));
        verify(() => mockRepository.getPostComments(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left(ServerFailure) when fetch operation fails',
      () async {
        // Arrange
        const tFailure = ServerFailure('Failed to load comments');
        when(
          () => mockRepository.getPostComments(tPostId),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tPostId);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.getPostComments(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
