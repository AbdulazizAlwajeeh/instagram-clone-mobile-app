import 'dart:async';
import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/features/create_post/presentation/bloc/create_post_bloc.dart';
import 'package:yemengram/features/create_post/presentation/pages/create_post_page.dart';
import 'package:yemengram/features/create_post/presentation/widgets/caption_input_field.dart';
import 'package:yemengram/features/create_post/presentation/widgets/media_picker.dart';

class MockCreatePostBloc extends MockBloc<CreatePostEvent, CreatePostState>
    implements CreatePostBloc {}

class MockFile extends Mock implements File {}

void main() {
  late MockCreatePostBloc mockCreatePostBloc;
  late StreamController<CreatePostState> stateStreamController;

  setUp(() {
    mockCreatePostBloc = MockCreatePostBloc();
    // Using a genuine broadcast StreamController to cleanly handle reactive pipeline transformations
    stateStreamController = StreamController<CreatePostState>.broadcast();
    when(
      () => mockCreatePostBloc.stream,
    ).thenAnswer((_) => stateStreamController.stream);
  });

  tearDown(() {
    stateStreamController.close();
    mockCreatePostBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<CreatePostBloc>.value(
        value: mockCreatePostBloc,
        child: const CreatePostPage(),
      ),
    );
  }

  group('CreatePostPage Widget Test Suite', () {
    testWidgets(
      'should render all static foundational subcomponents correctly in default state',
      (tester) async {
        // arrange
        when(
          () => mockCreatePostBloc.state,
        ).thenReturn(const CreatePostInitial());

        // act
        await tester.pumpWidget(createWidgetUnderTest());

        // assert
        expect(find.text('New Post'), findsOneWidget);
        expect(find.text('Publish'), findsOneWidget);
        expect(find.byType(MediaPickerPlaceholder), findsOneWidget);
        expect(find.byType(CaptionInputField), findsOneWidget);
      },
    );

    testWidgets(
      'should show CircularProgressIndicator in appBar actions layout when state is loading',
      (tester) async {
        // arrange
        when(
          () => mockCreatePostBloc.state,
        ).thenReturn(const CreatePostLoading());

        // act
        await tester.pumpWidget(createWidgetUnderTest());

        // assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Publish'), findsNothing);
      },
    );

    testWidgets(
      'should print validation warning snackbar when submit triggers without image selection',
      (tester) async {
        // arrange
        when(
          () => mockCreatePostBloc.state,
        ).thenReturn(const CreatePostInitial());

        // act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.text('Publish'));
        await tester.pump();

        // assert
        expect(find.text('Please select an image first.'), findsOneWidget);
      },
    );

    testWidgets(
      'should display standard error snackbar content when state stream yields CreatePostFailure',
      (tester) async {
        // arrange
        when(
          () => mockCreatePostBloc.state,
        ).thenReturn(const CreatePostInitial());

        // act
        await tester.pumpWidget(createWidgetUnderTest());

        // Inject error event into the controller stream to emulate operational lifecycle transitions
        stateStreamController.add(
          const CreatePostFailure(
            'Missing database bucket write authorizations',
          ),
        );
        await tester.pump();

        // assert
        expect(
          find.text('Missing database bucket write authorizations'),
          findsOneWidget,
        );
      },
    );
  });
}
