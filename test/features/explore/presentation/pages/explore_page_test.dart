import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:yemengram/features/explore/presentation/pages/explore_page.dart';

class MockExploreBloc extends Mock implements ExploreBloc {}

class MockPost extends Mock implements Post {}

void main() {
  late MockExploreBloc mockExploreBloc;
  late List<Post> tPosts;

  setUpAll(() {
    registerFallbackValue(const ExploreInitial());
    registerFallbackValue(const ExploreFetchRequested());
  });

  setUp(() {
    mockExploreBloc = MockExploreBloc();

    // Build a real broadcast stream controller to handle state transformations gracefully
    StreamController<ExploreState> stateStreamController =
        StreamController<ExploreState>.broadcast();

    // Stub the stream signature to point directly to our active broadcast stream
    when(
      () => mockExploreBloc.stream,
    ).thenAnswer((_) => stateStreamController.stream);

    final mockPost1 = MockPost();
    when(() => mockPost1.id).thenReturn('1');
    when(() => mockPost1.mediaUrl).thenReturn('https://example.com');

    final mockPost2 = MockPost();
    when(() => mockPost2.id).thenReturn('2');
    when(() => mockPost2.mediaUrl).thenReturn('https://example.com');

    tPosts = [mockPost1, mockPost2];
  });

  Widget buildTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<ExploreBloc>.value(
        value: mockExploreBloc,
        child: body,
      ),
    );
  }

  testWidgets(
    'should render a text search field matching design specifications',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockExploreBloc.state).thenReturn(const ExploreInitial());

      // Act
      await tester.pumpWidget(buildTestableWidget(const ExplorePage()));

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    },
  );

  testWidgets(
    'should show CircularProgressIndicator when the state evaluates to loading with no cache',
    (WidgetTester tester) async {
      // Arrange
      when(
        () => mockExploreBloc.state,
      ).thenReturn(const ExploreLoading(posts: null));

      // Act
      await tester.pumpWidget(buildTestableWidget(const ExplorePage()));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should display failure text block when the state transitions into explore failure',
    (WidgetTester tester) async {
      // Arrange
      const tErrorMessage = 'An error occurred fetching posts';
      when(() => mockExploreBloc.state).thenReturn(
        const ExploreFailure(errorMessage: tErrorMessage, posts: null),
      );

      // Act
      await tester.pumpWidget(buildTestableWidget(const ExplorePage()));

      // Assert
      expect(find.text(tErrorMessage), findsOneWidget);
    },
  );

  testWidgets(
    'should render a continuous message notice when explore result collection returns empty list',
    (WidgetTester tester) async {
      // Arrange
      when(
        () => mockExploreBloc.state,
      ).thenReturn(const ExploreSuccess(posts: []));

      // Act
      await tester.pumpWidget(buildTestableWidget(const ExplorePage()));

      // Assert
      expect(find.text('No posts found for exploration.'), findsOneWidget);
    },
  );

  testWidgets(
    'should build items into a GridView layout once explore collection succeeds',
    (WidgetTester tester) async {
      // Http testing boundaries override: provide empty response profiles for internal network layout bindings
      // Alternatively relying on errorBuilder execution layout inside target Image widgets.
      when(
        () => mockExploreBloc.state,
      ).thenReturn(ExploreSuccess(posts: tPosts));

      // Act
      await tester.pumpWidget(buildTestableWidget(const ExplorePage()));
      await tester.pump();

      // Assert
      expect(find.byType(GridView), findsOneWidget);
    },
  );
}
