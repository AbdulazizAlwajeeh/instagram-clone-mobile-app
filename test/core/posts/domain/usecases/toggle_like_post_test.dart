import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/repositories/post_detail_repository.dart';
import 'package:yemengram/core/posts/domain/usecases/toggle_lilke_post.dart';

class MockPostDetailRepository extends Mock implements PostDetailRepository {}

void main() {
  late ToggleLikePost useCase;
  late MockPostDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockPostDetailRepository();
    useCase = ToggleLikePost(mockRepository);
  });

  const tPostId = 'post_123';

  group('ToggleLikePost UseCase Tests', () {
    test(
      'should return Right(unit) from repository when liking/unliking succeeds',
      () async {
        // Arrange
        when(
          () => mockRepository.toggleLikePost(tPostId),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        final result = await useCase(tPostId);

        // Assert
        expect(result, const Right(unit));
        verify(() => mockRepository.toggleLikePost(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left(ServerFailure) from repository when action fails',
      () async {
        // Arrange
        const tFailure = ServerFailure('Unable to process request');
        when(
          () => mockRepository.toggleLikePost(tPostId),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tPostId);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.toggleLikePost(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
