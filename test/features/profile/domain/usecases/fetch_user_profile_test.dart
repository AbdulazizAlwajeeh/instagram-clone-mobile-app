import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/profile/domain/entities/user_profile.dart';
import 'package:yemengram/features/profile/domain/repositories/profile_repository.dart';
import 'package:yemengram/features/profile/domain/usecases/fetch_user_profile.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockUserProfile extends Mock implements UserProfile {}

void main() {
  late FetchUserProfile useCase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    useCase = FetchUserProfile(mockProfileRepository);
  });

  const tUserId = 'user_001';
  final tUserProfile = MockUserProfile();

  test(
    'should fetch user profile from repository when given a user ID string parameter',
    () async {
      when(
        () => mockProfileRepository.getUserProfile(any(that: isA<String>())),
      ).thenAnswer((_) async => Right(tUserProfile));

      final result = await useCase(tUserId);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not emit a failure state'),
        (profile) => expect(profile, tUserProfile),
      );
      verify(() => mockProfileRepository.getUserProfile(tUserId)).called(1);
    },
  );

  test(
    'should return Left(ServerFailure) when the repository data transaction fails',
    () async {
      when(
        () => mockProfileRepository.getUserProfile(any(that: isA<String>())),
      ).thenAnswer((_) async => const Left(ServerFailure('User not found')));

      final result = await useCase(tUserId);

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).message, 'User not found');
      }, (success) => fail('Should not emit a success payload'));
      verify(() => mockProfileRepository.getUserProfile(tUserId)).called(1);
    },
  );
}
