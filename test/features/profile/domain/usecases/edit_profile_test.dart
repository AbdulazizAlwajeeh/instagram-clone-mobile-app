import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/profile/domain/repositories/profile_repository.dart';
import 'package:yemengram/features/profile/domain/usecases/edit_profile.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late EditProfile useCase;
  late MockProfileRepository mockProfileRepository;

  setUpAll(() {
    registerFallbackValue(const EditProfileParams());
  });

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    useCase = EditProfile(mockProfileRepository);
  });

  const tParams = EditProfileParams(
    username: 'updated_user',
    fullName: 'Updated Name',
    bio: 'Updated biography text',
    imageFile: null,
  );

  test(
    'should pass parameters to repository and return Right(unit) on success',
    () async {
      when(
        () => mockProfileRepository.editProfile(
          username: any(named: 'username'),
          fullName: any(named: 'fullName'),
          bio: any(named: 'bio'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer((_) async => const Right(unit));

      final result = await useCase(tParams);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not emit a failure'),
        (success) => expect(success, unit),
      );
      verify(
        () => mockProfileRepository.editProfile(
          username: tParams.username,
          fullName: tParams.fullName,
          bio: tParams.bio,
          imageFile: tParams.imageFile,
        ),
      ).called(1);
    },
  );

  test(
    'should return Failure when repository modification updates fail',
    () async {
      when(
        () => mockProfileRepository.editProfile(
          username: any(named: 'username'),
          fullName: any(named: 'fullName'),
          bio: any(named: 'bio'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer(
        (_) async => const Left(ServerFailure('Database update rejection')),
      );

      final result = await useCase(tParams);

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).message, 'Database update rejection');
      }, (success) => fail('Should not emit success'));
      verify(
        () => mockProfileRepository.editProfile(
          username: tParams.username,
          fullName: tParams.fullName,
          bio: tParams.bio,
          imageFile: tParams.imageFile,
        ),
      ).called(1);
    },
  );
}
