import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/auth/domain/repositories/auth_repository.dart';
import 'package:yemengram/features/auth/domain/usecases/user_sign_up.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UserSignUp useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = UserSignUp(mockAuthRepository);
  });

  const tEmail = 'register@example.com';
  const tPassword = 'securePassword123';
  const tUsername = 'new_user_handle';

  const tSignUpParams = SignUpParams(
    email: tEmail,
    password: tPassword,
    username: tUsername,
  );

  const tAppUser = AppUser(
    id: 'generated_id_001',
    email: tEmail,
    username: tUsername,
  );

  test(
    'should sign up user and return AppUser when repository setup succeeds',
    () async {
      // Arrange
      when(
        () => mockAuthRepository.signUpWithEmailPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
        ),
      ).thenAnswer((_) async => const Right(tAppUser));

      // Act
      final result = await useCase(tSignUpParams);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return a failure'), (user) {
        expect(user.id, tAppUser.id);
        expect(user.email, tEmail);
        expect(user.username, tUsername);
      });
      verify(
        () => mockAuthRepository.signUpWithEmailPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should return an AuthFailure when registration fails at repository level',
    () async {
      // Arrange
      const tFailure = AuthFailure('Email already in use');
      when(
        () => mockAuthRepository.signUpWithEmailPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tSignUpParams);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, tFailure.message),
        (user) => fail('Should not return an AppUser profile on failure'),
      );
      verify(
        () => mockAuthRepository.signUpWithEmailPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
      ).called(1);
    },
  );
}
