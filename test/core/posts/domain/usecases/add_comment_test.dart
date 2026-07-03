import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/repositories/post_detail_repository.dart';
import 'package:yemengram/core/posts/domain/usecases/add_comment.dart';

class MockPostDetailRepository extends Mock implements PostDetailRepository {}

void main() {
  late AddComment useCase;
  late MockPostDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockPostDetailRepository();
    useCase = AddComment(mockRepository);
  });

  const tParams = AddCommentParams(postId: 'post_123', text: 'Amazing visual!');

  group('AddComment UseCase Tests', () {
    test(
      'should pass individual params elements down to repository and return Right(unit) on success',
      () async {
        // Arrange
        when(
          () => mockRepository.addComment(
            postId: tParams.postId,
            text: tParams.text,
          ),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, const Right(unit));
        verify(
          () => mockRepository.addComment(
            postId: tParams.postId,
            text: tParams.text,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left(ServerFailure) when creation write execution fails',
      () async {
        // Arrange
        const tFailure = ServerFailure('Comment posting blocked');
        when(
          () => mockRepository.addComment(
            postId: tParams.postId,
            text: tParams.text,
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, const Left(tFailure));
        verify(
          () => mockRepository.addComment(
            postId: tParams.postId,
            text: tParams.text,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
