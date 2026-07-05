import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:yemengram/features/feed/presentation/pages/feed_page.dart';

class MockFeedBloc extends Mock implements FeedBloc {}

class MockPost extends Mock implements Post {}

class MockAuthor extends Mock implements AppUser {}

void main() {
  late MockFeedBloc mockFeedBloc;
  // ignore: unused_local_variable
  late List<Post> tPosts;

  setUpAll(() {
    registerFallbackValue(FeedFetchInitialPosts());
  });

  setUp(() {
    mockFeedBloc = MockFeedBloc();

    // Stub the required stream framework targets to isolate the widget under test
    when(
      () => mockFeedBloc.stream,
    ).thenAnswer((_) => const Stream<FeedState>.empty());

    final mockPost = MockPost();
    final mockAuthor = MockAuthor();
    when(() => mockPost.id).thenReturn('post-1');
    when(() => mockPost.author).thenReturn(mockAuthor);

    tPosts = [mockPost];
  });

  Widget buildTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<FeedBloc>.value(value: mockFeedBloc, child: body),
    );
  }

  testWidgets(
    'should render progress spinner when feed status evaluates to loading',
    (WidgetTester tester) async {
      // Arrange
      when(
        () => mockFeedBloc.state,
      ).thenReturn(const FeedState(status: FeedStatus.loading));

      // Act
      await tester.pumpWidget(buildTestableWidget(const FeedPage()));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(
        () => mockFeedBloc.add(any(that: isA<FeedFetchInitialPosts>())),
      ).called(1);
    },
  );

  testWidgets(
    'should render a specific description message when failure status is broadcast',
    (WidgetTester tester) async {
      // Arrange
      const tError = 'Failed network pipeline synchronization';
      when(() => mockFeedBloc.state).thenReturn(
        const FeedState(status: FeedStatus.failure, errorMessage: tError),
      );

      // Act
      await tester.pumpWidget(buildTestableWidget(const FeedPage()));

      // Assert
      expect(find.text(tError), findsOneWidget);
    },
  );

  testWidgets(
    'should display specific text notice when the active feed records array is completely empty',
    (WidgetTester tester) async {
      // Arrange
      when(
        () => mockFeedBloc.state,
      ).thenReturn(const FeedState(status: FeedStatus.success, posts: []));

      // Act
      await tester.pumpWidget(buildTestableWidget(const FeedPage()));

      // Assert
      expect(
        find.text('Your feed is empty. Try following some creators!'),
        findsOneWidget,
      );
    },
  );
}
