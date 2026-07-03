import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/app_user/presentation/cubit/current_user_cubit.dart';
import 'package:yemengram/core/error/failures.dart' as failure;
import 'package:yemengram/core/usecase/usecase.dart';
import 'package:yemengram/features/auth/domain/usecases/get_current_user.dart';
import 'package:yemengram/features/auth/domain/usecases/user_sign_in.dart';
import 'package:yemengram/features/auth/domain/usecases/user_sign_out.dart';
import 'package:yemengram/features/auth/domain/usecases/user_sign_up.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_event.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_state.dart';

class MockUserSignUp extends Mock implements UserSignUp {}

class MockUserSignIn extends Mock implements UserSignIn {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockUserSignOut extends Mock implements UserSignOut {}

class MockCurrentUserCubit extends Mock implements CurrentUserCubit {}

void main() {
  late AuthBloc authBloc;
  late MockUserSignUp mockUserSignUp;
  late MockUserSignIn mockUserSignIn;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockUserSignOut mockUserSignOut;
  late MockCurrentUserCubit mockCurrentUserCubit;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUsername = 'testuser';
  const tErrorMessage = 'An error occurred';

  const tAppUser = AppUser(id: 'user_123', email: tEmail, username: tUsername);

  setUp(() {
    mockUserSignUp = MockUserSignUp();
    mockUserSignIn = MockUserSignIn();
    mockGetCurrentUser = MockGetCurrentUser();
    mockUserSignOut = MockUserSignOut();
    mockCurrentUserCubit = MockCurrentUserCubit();

    authBloc = AuthBloc(
      userSignUp: mockUserSignUp,
      userSignIn: mockUserSignIn,
      getCurrentUser: mockGetCurrentUser,
      userSignOut: mockUserSignOut,
      currentUserCubit: mockCurrentUserCubit,
    );
  });

  // Clean up BLoC after each test case
  tearDown(() {
    authBloc.close();
  });

  // Register mock parameters for mocktail calls matching custom types
  setUpAll(() {
    registerFallbackValue(
      const SignUpParams(email: '', password: '', username: ''),
    );
    registerFallbackValue(const SignInParams(email: '', password: ''));
    registerFallbackValue(NoParams());
  });

  test('Initial state should be AuthInitial', () {
    expect(authBloc.state, isA<AuthInitial>());
  });

  group('AuthSignUp', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, SignUpSuccess] when user sign up is successful',
      build: () {
        when(
          () => mockUserSignUp(any()),
        ).thenAnswer((_) async => const Right(tAppUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignUp(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
      ),
      expect: () => [isA<AuthLoading>(), isA<SignUpSuccess>()],
      verify: (_) {
        verify(() => mockUserSignUp(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when user sign up fails',
      build: () {
        when(() => mockUserSignUp(any())).thenAnswer(
          (_) async => const Left(failure.ServerFailure(tErrorMessage)),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignUp(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
      ),
      expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
    );
  });

  group('AuthSignIn', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] and updates current user cubit when sign in succeeds',
      build: () {
        when(
          () => mockUserSignIn(any()),
        ).thenAnswer((_) async => const Right(tAppUser));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const AuthSignIn(email: tEmail, password: tPassword)),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
      verify: (_) {
        verify(() => mockCurrentUserCubit.updateUser(tAppUser)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when sign in fails',
      build: () {
        when(
          () => mockUserSignIn(any()),
        ).thenAnswer((_) async => Left(failure.AuthFailure(tErrorMessage)));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const AuthSignIn(email: tEmail, password: tPassword)),
      expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
      verify: (_) {
        verifyZeroInteractions(mockCurrentUserCubit);
      },
    );
  });

  group('AuthCheckSession', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] and updates current user cubit when active session is found',
      build: () {
        when(
          () => mockGetCurrentUser(any()),
        ).thenAnswer((_) async => const Right(tAppUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckSession()),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
      verify: (_) {
        verify(() => mockCurrentUserCubit.updateUser(tAppUser)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthInitial] and clears cubit when no active session exists (user is null)',
      build: () {
        when(
          () => mockGetCurrentUser(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckSession()),
      expect: () => [isA<AuthLoading>(), isA<AuthInitial>()],
      verify: (_) {
        verify(() => mockCurrentUserCubit.clearUser()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when session verification fails',
      build: () {
        when(() => mockGetCurrentUser(any())).thenAnswer(
          (_) async => const Left(failure.ServerFailure(tErrorMessage)),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckSession()),
      expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
    );
  });

  group('AuthSignOut', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthInitial] and flushes user cubit session on sign out success',
      build: () {
        when(
          () => mockUserSignOut(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignOut()),
      expect: () => [isA<AuthLoading>(), isA<AuthInitial>()],
      verify: (_) {
        verify(() => mockCurrentUserCubit.clearUser()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when sign out fails',
      build: () {
        when(() => mockUserSignOut(any())).thenAnswer(
          (_) async => const Left(failure.ServerFailure(tErrorMessage)),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignOut()),
      expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
    );
  });
}
