import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/app_user/presentation/cubit/current_user_cubit.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/create_post/domain/usecases/create_post_usecase.dart';
import 'package:yemengram/features/create_post/presentation/bloc/create_post_bloc.dart';

// Mock core architecture classes
class MockCreatePost extends Mock implements CreatePost {}

class MockCurrentUserCubit extends Mock implements CurrentUserCubit {}

class MockFile extends Mock implements File {}

/// Fake params container to satisfy mocktail argument matching engine hooks
class FakeCreatePostParams extends Fake implements CreatePostParams {}

void main() {
  late CreatePostBloc bloc;
  late MockCreatePost mockCreatePost;
  late MockCurrentUserCubit mockCurrentUserCubit;
  late MockFile mockFile;
  late AppUser tUser;

  const tCaption = 'BLoC operational stream testing metadata';

  setUpAll(() {
    // Prevent Sound Null Safety type validation runtime panics inside verification blocks
    registerFallbackValue(FakeCreatePostParams());
  });

  setUp(() {
    mockCreatePost = MockCreatePost();
    mockCurrentUserCubit = MockCurrentUserCubit();
    mockFile = MockFile();
    tUser = const AppUser(
      id: 'user_test_id_55',
      email: 'test@example.com',
      username: 'test_dev',
      avatarUrl: null,
    );

    bloc = CreatePostBloc(
      createPostUseCase: mockCreatePost,
      currentUserCubit: mockCurrentUserCubit,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('CreatePostBloc Stream Flow Core Engine Diagnostics', () {
    test('Initial BLoC base layout state should be CreatePostInitial', () {
      expect(bloc.state, const CreatePostInitial());
    });

    blocTest<CreatePostBloc, CreatePostState>(
      'should emit [CreatePostLoading, CreatePostFailure] when user profile is not authenticated',
      build: () {
        // Simulating unauthenticated context profiles
        when(
          () => mockCurrentUserCubit.state,
        ).thenReturn(const CurrentUserInitial());
        return bloc;
      },
      act: (bloc) =>
          bloc.add(PublishPostEvent(caption: tCaption, mediaFile: mockFile)),
      expect: () => [
        const CreatePostLoading(),
        const CreatePostFailure('You must be logged in to publish a post.'),
      ],
      verify: (_) {
        verifyNever(() => mockCreatePost(any(that: isA<CreatePostParams>())));
      },
    );

    blocTest<CreatePostBloc, CreatePostState>(
      'should emit [CreatePostLoading, CreatePostSuccess] when authorization holds and usecase fulfills successfully',
      build: () {
        when(
          () => mockCurrentUserCubit.state,
        ).thenReturn(CurrentUserLoggedIn(tUser));
        when(
          () => mockCreatePost(any(that: isA<CreatePostParams>())),
        ).thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(PublishPostEvent(caption: tCaption, mediaFile: mockFile)),
      expect: () => [const CreatePostLoading(), const CreatePostSuccess()],
      verify: (_) {
        verify(
          () => mockCreatePost(any(that: isA<CreatePostParams>())),
        ).called(1);
      },
    );

    blocTest<CreatePostBloc, CreatePostState>(
      'should emit [CreatePostLoading, CreatePostFailure] containing correct payload when usecase runtime returns Failure',
      build: () {
        when(
          () => mockCurrentUserCubit.state,
        ).thenReturn(CurrentUserLoggedIn(tUser));
        when(
          () => mockCreatePost(any(that: isA<CreatePostParams>())),
        ).thenAnswer(
          (_) async =>
              const Left(ServerFailure('Timeout across public gateways')),
        );
        return bloc;
      },
      act: (bloc) =>
          bloc.add(PublishPostEvent(caption: tCaption, mediaFile: mockFile)),
      expect: () => [
        isA<CreatePostLoading>(),
        isA<CreatePostFailure>().having(
          (state) => state.errorMessage,
          'message',
          'Timeout across public gateways',
        ),
      ],
    );
  });
}
