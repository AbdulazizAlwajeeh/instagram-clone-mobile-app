import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/features/profile/domain/repositories/profile_repository.dart';
import 'package:yemengram/features/profile/domain/usecases/fetch_user_posts.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockPost extends Mock implements Post {}

void main() {
  late FetchUserPosts useCase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    useCase = FetchUserPosts(mockProfileRepository);
  });

  const tUserId = 'user_987';
  final tPostsList = [MockPost(), MockPost()];

  test(
    'should fetch user posts from repository when given a user ID string parameter',
    () async {
      when(
        () => mockProfileRepository.getUserPosts(any(that: isA<String>())),
      ).thenAnswer((_) async => Right(tPostsList));

      final result = await useCase(tUserId);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not emit a failure state'),
        (posts) => expect(posts, tPostsList),
      );
      verify(() => mockProfileRepository.getUserPosts(tUserId)).called(1);
    },
  );

  test(
    'should return Left(ServerFailure) when the repository data transaction fails',
    () async {
      when(
        () => mockProfileRepository.getUserPosts(any(that: isA<String>())),
      ).thenAnswer(
        (_) async => const Left(ServerFailure('Database connection timeout')),
      );

      final result = await useCase(tUserId);

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(
          (failure as ServerFailure).message,
          'Database connection timeout',
        );
      }, (success) => fail('Should not emit a success payload'));
      verify(() => mockProfileRepository.getUserPosts(tUserId)).called(1);
    },
  );
}
