import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/usecase/usecase.dart';
import 'package:yemengram/features/auth/domain/repositories/auth_repository.dart';
import 'package:yemengram/features/auth/domain/usecases/get_current_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentUser useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = GetCurrentUser(mockAuthRepository);
  });

  const tAppUser = AppUser(
    id: 'user_123',
    email: 'test@example.com',
    username: 'testuser',
  );

  test(
    'should get current user from the repository when session exists',
    () async {
      // Arrange
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(tAppUser));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (user) => expect(user?.id, tAppUser.id),
      );
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should return null from repository when no active session exists',
    () async {
      // Arrange
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (user) => expect(user, isNull),
      );
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
    },
  );

  test('should return failure when repository call fails', () async {
    // Arrange
    const tFailure = ServerFailure('Session error');
    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(NoParams());

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, tFailure.message),
      (user) => fail('Should not return user'),
    );
    verify(() => mockAuthRepository.getCurrentUser()).called(1);
  });
}
