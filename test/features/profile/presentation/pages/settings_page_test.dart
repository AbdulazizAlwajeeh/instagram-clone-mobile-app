import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/theme/presentation/bloc/theme_bloc.dart';
import 'package:yemengram/core/theme/presentation/bloc/theme_event.dart';
import 'package:yemengram/core/theme/presentation/bloc/theme_state.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_event.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_state.dart';
import 'package:yemengram/features/profile/presentation/pages/settings_page.dart';

class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockThemeBloc mockThemeBloc;
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(const ThemeToggleRequested());
    registerFallbackValue(AuthSignOut());
  });

  setUp(() {
    mockThemeBloc = MockThemeBloc();
    mockAuthBloc = MockAuthBloc();

    // Stub necessary core baseline layout states
    when(
      () => mockThemeBloc.state,
    ).thenReturn(const ThemeLoaded(ThemeMode.light));
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  Widget createWidgetUnderTest({Brightness brightness = Brightness.light}) {
    return MaterialApp(
      theme: ThemeData(
        brightness: brightness,
        useMaterial3: true,
        textTheme: const TextTheme(
          labelSmall: TextStyle(fontSize: 10),
          bodyLarge: TextStyle(fontSize: 16),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>.value(value: mockThemeBloc),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        ],
        child: const SettingsPage(),
      ),
    );
  }

  testWidgets(
    'should render all baseline navigation elements and preference sections successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Dark Theme'), findsOneWidget);
      expect(find.text('Account Actions'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    },
  );

  testWidgets(
    'should dispatch ThemeToggleRequested event downstream when the preference switch is clicked',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pump();

      verify(
        () => mockThemeBloc.add(any(that: isA<ThemeToggleRequested>())),
      ).called(1);
    },
  );

  testWidgets(
    'should display signout dialog modal window and trigger AuthSignOut when accepted',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Locate the structural card interaction cell targeting sign out routines
      final signOutTileFinder = find.ancestor(
        of: find.text('Sign Out'),
        matching: find.byType(ListTile),
      );
      expect(signOutTileFinder, findsOneWidget);

      await tester.tap(signOutTileFinder);
      await tester.pumpAndSettle(); // Settle confirmation entry animations

      // Verify modal overlay parameters populate cleanly
      expect(
        find.text('Are you sure you want to log out of your account?'),
        findsOneWidget,
      );

      // Tap confirm button link inside standard modal actions bar
      final confirmButtonFinder = find.widgetWithText(TextButton, 'Sign Out');
      expect(confirmButtonFinder, findsOneWidget);

      await tester.tap(confirmButtonFinder);
      await tester.pumpAndSettle();

      // Verify modal pops off stack and events reach down stream authorization cores
      expect(
        find.text('Are you sure you want to log out of your account?'),
        findsNothing,
      );
      verify(() => mockAuthBloc.add(any(that: isA<AuthSignOut>()))).called(1);
    },
  );
}
