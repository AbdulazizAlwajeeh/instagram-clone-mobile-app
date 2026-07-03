import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/usecase/usecase.dart';
import 'package:yemengram/features/auth/domain/repositories/auth_repository.dart';
import 'package:yemengram/features/auth/domain/usecases/user_sign_out.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UserSignOut useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = UserSignOut(mockAuthRepository);
  });

  test('should successfully sign out from the repository', () async {
    // Arrange
    when(
      () => mockAuthRepository.signOut(),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase(NoParams());

    // Assert
    expect(result.isRight(), true);
    verify(() => mockAuthRepository.signOut()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return a failure when repository sign out fails', () async {
    // Arrange
    const tFailure = ServerFailure('Sign out failed');
    when(
      () => mockAuthRepository.signOut(),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(NoParams());

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, tFailure.message),
      (_) => fail('Should not return a success channel'),
    );
    verify(() => mockAuthRepository.signOut()).called(1);
  });
}
