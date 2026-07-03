import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_event.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_state.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_up_page.dart';
import 'package:yemengram/features/auth/presentation/widgets/auth_action.dart';
import 'package:yemengram/features/auth/presentation/widgets/auth_header.dart';
import 'package:yemengram/features/auth/presentation/widgets/auth_text_field.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthSignUp(email: '', password: '', username: ''),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const SignUpPage(),
        ),
      ),
    );
  }

  group('SignUpPage Layout & Interaction Tests', () {
    testWidgets(
      'should render all modular custom auth components on initialization',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(AuthHeader), findsOneWidget);
        expect(
          find.byType(AuthTextField),
          findsNWidgets(3),
        ); // Username, Email, Password
        expect(find.byType(AuthActionBlock), findsOneWidget);
      },
    );

    testWidgets(
      'should display inline validation errors when text fields are empty on submit',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        // Target and tap the primary registration button version-safely
        final buttonFinder = find.descendant(
          of: find.byType(AuthActionBlock),
          matching: find.text('Sign Up'),
        );
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        expect(find.text('Username cannot be empty'), findsOneWidget);
        expect(find.text('Enter a valid email'), findsOneWidget);
        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );

        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets(
      'should dispatch AuthSignUp event when text validations pass successfully',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        // Enter valid fields into text boxes by direct layout index order
        await tester.enterText(find.byType(EditableText).at(0), 'alex_dev');
        await tester.enterText(
          find.byType(EditableText).at(1),
          'alex@example.com',
        );
        await tester.enterText(find.byType(EditableText).at(2), 'secure123');
        await tester.pump();

        final buttonFinder = find.descendant(
          of: find.byType(AuthActionBlock),
          matching: find.text('Sign Up'),
        );
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        // Verify that the correct event payload properties were sent out
        verify(
          () => mockAuthBloc.add(
            any(
              that: isA<AuthSignUp>()
                  .having((e) => e.username, 'username', 'alex_dev')
                  .having((e) => e.email, 'email', 'alex@example.com')
                  .having((e) => e.password, 'password', 'secure123'),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should reflect isLoading flag status inside fields when state is AuthLoading',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthLoading());

        await tester.pumpWidget(createWidgetUnderTest());

        final usernameField = tester.widget<AuthTextField>(
          find.widgetWithText(AuthTextField, 'Username'),
        );
        final emailField = tester.widget<AuthTextField>(
          find.widgetWithText(AuthTextField, 'Email'),
        );
        final passwordField = tester.widget<AuthTextField>(
          find.widgetWithText(AuthTextField, 'Password'),
        );
        final actionBlock = tester.widget<AuthActionBlock>(
          find.byType(AuthActionBlock),
        );

        expect(usernameField.enabled, false);
        expect(emailField.enabled, false);
        expect(passwordField.enabled, false);
        expect(actionBlock.isLoading, true);
      },
    );

    testWidgets(
      'should display error snackbar when AuthFailure state is emitted',
      (WidgetTester tester) async {
        whenListen(
          mockAuthBloc,
          Stream.fromIterable([
            AuthInitial(),
            const AuthFailure('Email already exists'),
          ]),
          initialState: AuthInitial(),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Email already exists'), findsOneWidget);
      },
    );

    testWidgets(
      'should display confirmation message snackbar when AuthSuccess is emitted',
      (WidgetTester tester) async {
        const tUser = AppUser(
          id: '1',
          email: 'alex@e.com',
          username: 'alex_dev',
        );
        whenListen(
          mockAuthBloc,
          Stream.fromIterable([AuthInitial(), const AuthSuccess(tUser)]),
          initialState: AuthInitial(),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Now confirm your email!'), findsOneWidget);
      },
    );
  });
}
