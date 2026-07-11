import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/repositories/post_detail_repository.dart';
import 'package:yemengram/core/posts/domain/usecases/report_post.dart';

// Create a mock class implementing the repository interface contract
class MockPostDetailRepository extends Mock implements PostDetailRepository {}

void main() {
  late ReportPost useCase;
  late MockPostDetailRepository mockRepository;

  // Runs before every individual test to guarantee a fresh slate
  setUp(() {
    mockRepository = MockPostDetailRepository();
    useCase = ReportPost(mockRepository);
  });

  const tPostId = 'post_123';

  group('ReportPost UseCase Tests', () {
    test(
      'should return Right(unit) from repository on a successful report submittal cycle',
      () async {
        // Arrange
        when(
          () => mockRepository.reportPost(postId: tPostId),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        final result = await useCase(tPostId);

        // Assert
        expect(result, const Right(unit));

        // Verify that the repository method was actually called exactly once
        verify(() => mockRepository.reportPost(postId: tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left(ServerFailure) from repository when operational call fails',
      () async {
        // Arrange
        const tFailure = ServerFailure('Post already reported');
        when(
          () => mockRepository.reportPost(postId: tPostId),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tPostId);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.reportPost(postId: tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
