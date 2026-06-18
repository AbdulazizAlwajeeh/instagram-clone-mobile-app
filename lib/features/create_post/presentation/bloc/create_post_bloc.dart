import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_user/presentation/cubit/current_user_cubit.dart';
import '../../domain/usecases/create_post_usecase.dart';

part 'create_post_event.dart';

part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePost _createPostUseCase;
  final CurrentUserCubit _currentUserCubit;

  CreatePostBloc({
    required CreatePost createPostUseCase,
    required CurrentUserCubit currentUserCubit,
  }) : _createPostUseCase = createPostUseCase,
       _currentUserCubit = currentUserCubit,
       super(const CreatePostInitial()) {
    on<PublishPostEvent>(_onPublishPost);
  }

  Future<void> _onPublishPost(
    PublishPostEvent event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(const CreatePostLoading());

    final userState = _currentUserCubit.state;

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

    result.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (unit) => emit(const CreatePostSuccess()),
    );
  }
}
