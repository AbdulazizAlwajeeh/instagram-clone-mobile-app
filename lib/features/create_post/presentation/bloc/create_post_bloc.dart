import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_user/presentation/cubit/current_user_cubit.dart';
import '../../domain/usecases/create_post_usecase.dart';

part 'create_post_event.dart';

part 'create_post_state.dart';

/// Presentation layer business logic component managing post production streams.
///
/// Listens to user interactions via events, reads context states from authentication
/// modules, and maps requests to domain layer use cases.
class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePost _createPostUseCase;
  final CurrentUserCubit _currentUserCubit;

  /// Initializes the BLoC by injecting required usecases and parent session managers.
  CreatePostBloc({
    required CreatePost createPostUseCase,
    required CurrentUserCubit currentUserCubit,
  }) : _createPostUseCase = createPostUseCase,
       _currentUserCubit = currentUserCubit,
       super(const CreatePostInitial()) {
    on<PublishPostEvent>(_onPublishPost);
  }

  /// Processes internal logic workflows when a user requests a post to be published.
  Future<void> _onPublishPost(
    PublishPostEvent event,
    Emitter<CreatePostState> emit,
  ) async {
    // Transition UI into an active asynchronous execution state
    emit(const CreatePostLoading());

    final userState = _currentUserCubit.state;

    // Reject processing immediately if the user is unauthenticated or has timed out
    if (userState is! CurrentUserLoggedIn) {
      emit(const CreatePostFailure('You must be logged in to publish a post.'));
      return;
    }
    final params = CreatePostParams(
      caption: event.caption,
      mediaFile: event.mediaFile,
      authorId: userState.user.id,
    );
    final result = await _createPostUseCase(params);

    // Unpack usecase result and transition downstream widgets to failure or success
    result.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (unit) => emit(const CreatePostSuccess()),
    );
  }
}
