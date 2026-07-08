import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/profile/domain/repositories/profile_repository.dart';
import 'package:yemengram/features/profile/domain/usecases/follow_user.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late FollowUser useCase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    useCase = FollowUser(mockProfileRepository);
  });

  const tTargetUserId = 'target_user_456';

  test(
    'should trigger follow tracking routine inside repository when valid parameters are sent',
    () async {
      when(
        () => mockProfileRepository.followUser(any(that: isA<String>())),
      ).thenAnswer((_) async => const Right(unit));

      final result = await useCase(tTargetUserId);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not emit a failure state'),
        (success) => expect(success, unit),
      );
      verify(() => mockProfileRepository.followUser(tTargetUserId)).called(1);
    },
  );

  test(
    'should bubble up Left(ServerFailure) when the repository data transaction drops out',
    () async {
      when(
        () => mockProfileRepository.followUser(any(that: isA<String>())),
      ).thenAnswer(
        (_) async => const Left(ServerFailure('Target profile index dropped')),
      );

      final result = await useCase(tTargetUserId);

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(
          (failure as ServerFailure).message,
          'Target profile index dropped',
        );
      }, (success) => fail('Should not emit a success payload'));
      verify(() => mockProfileRepository.followUser(tTargetUserId)).called(1);
    },
  );
}
