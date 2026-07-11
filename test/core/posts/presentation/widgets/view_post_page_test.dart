import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_bloc.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_state.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_event.dart';
import 'package:yemengram/core/posts/presentation/pages/view_post_page.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card.dart';

// Create a mock class implementing the Bloc contract for UI stream simulations
class MockPostDetailBloc extends MockBloc<PostDetailEvent, PostDetailState>
    implements PostDetailBloc {}

void main() {
  late MockPostDetailBloc mockBloc;
  const tPostId = 'post_123';

  final tPost = Post(
    id: tPostId,
    author: const AppUser(id: '1', email: 'e', username: 'u'),
    mediaUrl: 'https://example.com',
    likesCount: 5,
    commentsCount: 2,
    createdAt: DateTime.now(),
    isLiked: false,
    reportedByMe: false,
  );

  setUp(() {
    mockBloc = MockPostDetailBloc();
  });

  setUpAll(() {
    registerFallbackValue(const PostReportSubmitted(postId: ''));
  });

  // Helper utility to wrap your widget with MaterialApp and the injected Bloc provider dependency
  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: BlocProvider<PostDetailBloc>.value(
        value: mockBloc,
        child: const ViewPostPage(postId: tPostId),
      ),
    );
  }

  group('ViewPostPage Widget Layout & Interaction Tests', () {
    testWidgets(
      'should render a full-screen CircularProgressIndicator when state is PostDetailLoading and post is null',
      (WidgetTester tester) async {
        // Arrange - Force the mock Bloc to emit a loading state configuration
        when(
          () => mockBloc.state,
        ).thenReturn(const PostDetailLoading(post: null, comments: []));

        // Act - Paint the widget interface onto the test screen canvas
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - Verify that the spinner is found and drawn cleanly
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'should display the specific error message on screen when state is PostDetailFailure and post is missing',
      (WidgetTester tester) async {
        // Arrange - Force a failure state simulation
        when(() => mockBloc.state).thenReturn(
          const PostDetailFailure(
            'Connection Timeout',
            post: null,
            comments: [],
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - Verify that the raw technical text appears on screen for the user
        expect(find.text('Connection Timeout'), findsOneWidget);
      },
    );

    testWidgets(
      'should render custom missing fallback message if state resolves with no data model values',
      (WidgetTester tester) async {
        // Arrange - Simulate initialization where no dataset exists yet
        when(() => mockBloc.state).thenReturn(const PostDetailInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('This post no longer exists.'), findsOneWidget);
      },
    );
  });

  testWidgets(
    'should render error SnackBar when state stream emits ReportingPostFailure side-effect',
    (WidgetTester tester) async {
      // Stream must start with an initial UI-rendering state, then transition to failure to fire the listener
      whenListen<PostDetailState>(
        mockBloc,
        Stream.fromIterable([
          ReportingPostSuccess(tPost, const []),
          const ReportingPostFailure('Database timeout error', null, []),
        ]),
        initialState: ReportingPostSuccess(tPost, const []),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester
          .pumpAndSettle(); // Complete SnackBar presentation animation frames

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Database timeout error'), findsOneWidget);
    },
  );

  testWidgets(
    'should render success SnackBar when state stream emits ReportingPostSuccess with reportedByMe true',
    (WidgetTester tester) async {
      final reportedPost = tPost.copyWith(reportedByMe: true);

      whenListen<PostDetailState>(
        mockBloc,
        Stream.fromIterable([
          ReportingPostSuccess(tPost, const []),
          ReportingPostSuccess(reportedPost, const []),
        ]),
        initialState: ReportingPostSuccess(tPost, const []),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Post successfully reported.'), findsOneWidget);
    },
  );

  testWidgets(
    'should dispatch PostReportSubmitted event to Bloc when report option item is tapped inside options sheet',
    (WidgetTester tester) async {
      // Stub the current state to safely draw the baseline PostCard component
      when(
        () => mockBloc.state,
      ).thenReturn(ReportingPostSuccess(tPost, const []));

      await tester.pumpWidget(createWidgetUnderTest());

      // Find and tap your PostCard more option toggle button layout to reveal sheet options
      final moreButton = find.byIcon(Icons.more_vert);
      if (moreButton.evaluate().isNotEmpty) {
        await tester.tap(moreButton);
      } else {
        await tester.tap(find.byType(PostCard));
      }
      await tester
          .pumpAndSettle(); // Complete modal slide-up transition timeline

      final reportOption = find.text('Report Post');
      expect(reportOption, findsOneWidget);
      await tester.tap(reportOption);
      await tester.pump();

      // 1. Capture the exact object that was passed into the add() function
      final captured = verify(() => mockBloc.add(captureAny())).captured;
      expect(captured.isNotEmpty, isTrue);

      final dispatchedEvent = captured.first as PostReportSubmitted;
      expect(dispatchedEvent.postId, tPostId);
    },
  );
}
