import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_bloc.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_state.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_event.dart';
import 'package:yemengram/core/posts/presentation/pages/view_post_page.dart';

// Create a mock class implementing the Bloc contract for UI stream simulations
class MockPostDetailBloc extends MockBloc<PostDetailEvent, PostDetailState>
    implements PostDetailBloc {}

void main() {
  late MockPostDetailBloc mockBloc;
  const tPostId = 'post_123';

  setUp(() {
    mockBloc = MockPostDetailBloc();
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
}
