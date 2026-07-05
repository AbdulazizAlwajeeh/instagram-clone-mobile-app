import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/core/usecase/usecase.dart';
import 'package:yemengram/features/explore/domain/repositories/explore_repository.dart';
import 'package:yemengram/features/explore/domain/usecases/get_all_posts.dart';

// Pure architectural contract mock bypassing concrete dependencies.
class MockExploreRepository extends Mock implements ExploreRepository {}

class MockPost extends Mock implements Post {}

void main() {
  late GetAllPosts useCase;
  late MockExploreRepository mockExploreRepository;

  setUp(() {
    mockExploreRepository = MockExploreRepository();
    useCase = GetAllPosts(mockExploreRepository);
  });

  final tPostsList = [MockPost(), MockPost()];
  const tFailureMessage = 'Server Connection Timeout Error';

  group('GetAllPosts UseCase', () {
    test(
      'should forward the exact call to the repository and return Right list of posts',
      () async {
        // Arrange
        when(
          () => mockExploreRepository.getAllPosts(),
        ).thenAnswer((_) async => Right(tPostsList));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result, equals(Right<Failure, List<Post>>(tPostsList)));
        verify(() => mockExploreRepository.getAllPosts()).called(1);
        verifyNoMoreInteractions(mockExploreRepository);
      },
    );

    test(
      'should forward the exact call to the repository and return Left ServerFailure upon rejection',
      () async {
        // Arrange
        when(
          () => mockExploreRepository.getAllPosts(),
        ).thenAnswer((_) async => const Left(ServerFailure(tFailureMessage)));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, equals(tFailureMessage));
          },
          (_) => fail(
            'Expected Left side return but received Right side instead.',
          ),
        );
        verify(() => mockExploreRepository.getAllPosts()).called(1);
        verifyNoMoreInteractions(mockExploreRepository);
      },
    );
  });
}
