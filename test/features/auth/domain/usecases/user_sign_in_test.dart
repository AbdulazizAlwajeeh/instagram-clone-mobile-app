import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/auth/domain/repositories/auth_repository.dart';
import 'package:yemengram/features/auth/domain/usecases/user_sign_in.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UserSignIn useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = UserSignIn(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tSignInParams = SignInParams(email: tEmail, password: tPassword);

  const tAppUser = AppUser(id: 'user_123', email: tEmail, username: 'testuser');

  test(
    'should sign in user with email and password from the repository',
    () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithEmailPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(tAppUser));

      // Act
      final result = await useCase(tSignInParams);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return a failure'),
        (user) => expect(user.id, tAppUser.id),
      );
      verify(
        () => mockAuthRepository.signInWithEmailPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test('should return a failure when repository login fails', () async {
    // Arrange
    const tFailure = AuthFailure('Invalid credentials');
    when(
      () => mockAuthRepository.signInWithEmailPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(tSignInParams);

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, tFailure.message),
      (user) => fail('Should not return a user'),
    );
    verify(
      () => mockAuthRepository.signInWithEmailPassword(
        email: tEmail,
        password: tPassword,
      ),
    ).called(1);
  });
}
