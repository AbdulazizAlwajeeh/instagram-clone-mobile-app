import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/profile/domain/repositories/profile_repository.dart';
import 'package:yemengram/features/profile/domain/usecases/check_username_availability.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late CheckUsernameAvailability useCase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    useCase = CheckUsernameAvailability(mockProfileRepository);
  });

  const tUsername = 'dev_ninja';

  test(
    'should forward request to repository and return availability status',
    () async {
      when(
        () => mockProfileRepository.checkUsernameAvailability(
          any(that: isA<String>()),
        ),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase(tUsername);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not emit a failure'),
        (available) => expect(available, isTrue),
      );
      verify(
        () => mockProfileRepository.checkUsernameAvailability(tUsername),
      ).called(1);
    },
  );

  test(
    'should return Failure when repository username transaction fails',
    () async {
      when(
        () => mockProfileRepository.checkUsernameAvailability(
          any(that: isA<String>()),
        ),
      ).thenAnswer((_) async => const Left(ServerFailure('Connection lost')));

      final result = await useCase(tUsername);

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).message, 'Connection lost');
      }, (success) => fail('Should not emit success'));
      verify(
        () => mockProfileRepository.checkUsernameAvailability(tUsername),
      ).called(1);
    },
  );
}
