import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/features/profile/domain/entities/user_profile.dart';
import 'package:yemengram/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:yemengram/features/profile/presentation/bloc/profile_event.dart';
import 'package:yemengram/features/profile/presentation/bloc/profile_state.dart';
import 'package:yemengram/features/profile/presentation/pages/profile_page.dart';

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

class MockUserProfile extends Mock implements UserProfile {}

class MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  late MockProfileBloc mockProfileBloc;
  late StreamController<ProfileState> stateStreamController;
  late MockUserProfile mockUserProfile;

  setUpAll(() {
    registerFallbackValue(ProfileInitial());
    registerFallbackValue(const ProfileRefreshRequested(userId: null));
  });

  setUp(() {
    mockProfileBloc = MockProfileBloc();
    stateStreamController = StreamController<ProfileState>.broadcast();
    mockUserProfile = MockUserProfile();

    when(
      () => mockProfileBloc.stream,
    ).thenAnswer((_) => stateStreamController.stream);

    when(() => mockUserProfile.id).thenReturn('user_123');
    when(() => mockUserProfile.username).thenReturn('yemen_coder');
    when(() => mockUserProfile.fullName).thenReturn('Yemen Coder');
    when(() => mockUserProfile.postsCount).thenReturn(0);
    when(() => mockUserProfile.followersCount).thenReturn(0);
    when(() => mockUserProfile.followingCount).thenReturn(0);
    when(() => mockUserProfile.isFollowing).thenReturn(false);
  });

  tearDown(() {
    stateStreamController.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: const ProfilePage(),
      ),
    );
  }

  testWidgets(
    'should display CircularProgressIndicator when state is ProfileLoading',
    (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(ProfileLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should display errorMessage text when state is ProfileLoadFailure',
    (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        const ProfileLoadFailure(errorMessage: 'Network Connection Lost'),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Network Connection Lost'), findsOneWidget);
    },
  );

  testWidgets(
    'should display username in AppBar and setup RefreshIndicator layout when state is ProfileLoadSuccess',
    (WidgetTester tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        ProfileLoadSuccess(
          profile: mockUserProfile,
          isMe: false,
          posts: const [],
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('yemen_coder'), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should trigger ProfileRefreshRequested event downstream inside lifecycle callback execution blocks when pull-to-refresh triggers',
    (WidgetTester tester) async {
      // Stub the initial baseline profile success screen layout state
      when(() => mockProfileBloc.state).thenReturn(
        ProfileLoadSuccess(
          profile: mockUserProfile,
          isMe: false,
          posts: const [],
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Simulate a physical pull-down gesture interaction on the scroll view area
      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0.0, 300.0),
        1000.0,
      );

      // Advance frames until the refresh indicator physics start triggering its callback execution
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Instantly inject a follow-up state into the broadcast stream controller.
      // This immediately unblocks the onRefresh method's .firstWhere(...) await handle.
      stateStreamController.add(
        ProfileLoadSuccess(
          profile: mockUserProfile,
          isMe: false,
          posts: const [],
        ),
      );

      // Execute a quick microtask flush frame to let the layout engine conclude cleanly
      await tester.pump();

      // Verify that the event was safely caught downstream by the presentation layer BLoC
      verify(
        () => mockProfileBloc.add(any(that: isA<ProfileRefreshRequested>())),
      ).called(1);
    },
  );
}
