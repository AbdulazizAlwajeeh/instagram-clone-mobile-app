import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/exceptions.dart';
import 'package:yemengram/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yemengram/features/auth/data/models/app_user_model.dart';
import 'package:yemengram/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUsername = 'testuser';
  const tServerErrorMessage = 'Invalid credentials';

  const tAppUserModel = AppUserModel(
    id: 'user_123',
    email: tEmail,
    username: tUsername,
  );

  group('signUpWithEmailPassword', () {
    test(
      'should return AppUser when call to remote data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.signUpWithEmailPassword(
            email: tEmail,
            password: tPassword,
            username: tUsername,
          ),
        ).thenAnswer((_) async => tAppUserModel);

        final result = await repository.signUpWithEmailPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        );

        // Verify it's a Right option and match fields
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return a failure'),
          (user) => expect(user.id, tAppUserModel.id),
        );
      },
    );

    test(
      'should return AuthFailure when remote data source throws a ServerException',
      () async {
        when(
          () => mockRemoteDataSource.signUpWithEmailPassword(
            email: tEmail,
            password: tPassword,
            username: tUsername,
          ),
        ).thenThrow(const ServerException(tServerErrorMessage));

        final result = await repository.signUpWithEmailPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        );

        // Verify it's a Left option and check the message property inside
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, tServerErrorMessage),
          (user) => fail('Should not return a user'),
        );
      },
    );

    test(
      'should return ServerFailure when remote data source throws an unexpected error',
      () async {
        final exception = Exception('Connection timeout');
        when(
          () => mockRemoteDataSource.signUpWithEmailPassword(
            email: tEmail,
            password: tPassword,
            username: tUsername,
          ),
        ).thenThrow(exception);

        final result = await repository.signUpWithEmailPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, exception.toString()),
          (user) => fail('Should not return a user'),
        );
      },
    );
  });

  group('signInWithEmailPassword', () {
    test('should return AppUser when login is successful', () async {
      when(
        () => mockRemoteDataSource.signInWithEmailPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tAppUserModel);

      final result = await repository.signInWithEmailPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return a failure'),
        (user) => expect(user.id, tAppUserModel.id),
      );
    });

    test('should return AuthFailure on ServerException', () async {
      when(
        () => mockRemoteDataSource.signInWithEmailPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenThrow(const ServerException(tServerErrorMessage));

      final result = await repository.signInWithEmailPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, tServerErrorMessage),
        (user) => fail('Should not return a user'),
      );
    });
  });

  group('signOut', () {
    test('should return right(null) when logout is successful', () async {
      when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async => {});

      final result = await repository.signOut();

      expect(result.isRight(), true);
    });

    test(
      'should return AuthFailure on ServerException during logout',
      () async {
        when(
          () => mockRemoteDataSource.signOut(),
        ).thenThrow(const ServerException(tServerErrorMessage));

        final result = await repository.signOut();

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, tServerErrorMessage),
          (user) => fail('Should not return data'),
        );
      },
    );
  });

  group('getCurrentUser', () {
    test('should return AppUser when a user session exists', () async {
      when(
        () => mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tAppUserModel);

      final result = await repository.getCurrentUser();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return a failure'),
        (user) => expect(user?.id, tAppUserModel.id),
      );
    });

    test(
      'should return right(null) when no active user session exists',
      () async {
        when(
          () => mockRemoteDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        final result = await repository.getCurrentUser();

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return a failure'),
          (user) => expect(user, isNull),
        );
      },
    );

    test(
      'should return AuthFailure on ServerException during session lookup',
      () async {
        when(
          () => mockRemoteDataSource.getCurrentUser(),
        ).thenThrow(const ServerException(tServerErrorMessage));

        final result = await repository.getCurrentUser();

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, tServerErrorMessage),
          (user) => fail('Should not return a user'),
        );
      },
    );
  });
}
