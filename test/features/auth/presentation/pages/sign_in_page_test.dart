import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_event.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_state.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_in_page.dart';
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
    registerFallbackValue(const AuthSignIn(email: '', password: ''));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const SignInPage(),
      ),
    );
  }

  group('SignInPage Layout & Interaction Tests', () {
    testWidgets(
      'should render all modular custom auth components on initialization',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(AuthHeader), findsOneWidget);
        expect(find.byType(AuthTextField), findsNWidgets(2));
        expect(find.byType(AuthActionBlock), findsOneWidget);
      },
    );

    testWidgets(
      'should display inline validation errors when text fields are empty on login submit',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        // Tap the primary login button to trigger form validations
        await tester.tap(find.text('Log In'));
        await tester.pump();

        expect(find.text('Enter a valid email'), findsOneWidget);
        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );

        // Verify that no event (like AuthSignIn) was added to the bloc
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets(
      'should dispatch AuthSignIn event when text validations pass successfully',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        // Enter valid credentials into form fields
        await tester.enterText(
          find.widgetWithText(AuthTextField, 'Email'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(AuthTextField, 'Password'),
          'password123',
        );

        await tester.tap(find.text('Log In'));
        await tester.pump();

        // Verify by matching the internal fields of the event instance using
        // Mocktail matchers
        verify(
          () => mockAuthBloc.add(
            any(
              that: isA<AuthSignIn>()
                  .having((e) => e.email, 'email', 'test@example.com')
                  .having((e) => e.password, 'password', 'password123'),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should reflect isLoading flag status inside subcomponents when state is AuthLoading',
      (WidgetTester tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthLoading());

        await tester.pumpWidget(createWidgetUnderTest());

        // Verify fields are deactivated by inspecting the subcomponent parameters
        final emailField = tester.widget<AuthTextField>(
          find.widgetWithText(AuthTextField, 'Email'),
        );
        final passwordField = tester.widget<AuthTextField>(
          find.widgetWithText(AuthTextField, 'Password'),
        );
        final actionBlock = tester.widget<AuthActionBlock>(
          find.byType(AuthActionBlock),
        );

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
            const AuthFailure('Invalid password'),
          ]),
          initialState: AuthInitial(),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(); // Trigger the listener state handling frame

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Invalid password'), findsOneWidget);
      },
    );
  });
}
