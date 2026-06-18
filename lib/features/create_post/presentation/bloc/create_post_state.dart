part of 'create_post_bloc.dart';

sealed class CreatePostState {
  const CreatePostState();
}

/// Represents the form widget in its default, resting state.
class CreatePostInitial extends CreatePostState {
  const CreatePostInitial();
}

/// Emitted immediately when the submission process kicks off to show a progress loader.
class CreatePostLoading extends CreatePostState {
  const CreatePostLoading();
}

/// Emitted upon successful server verification. Contains 0 payload.
class CreatePostSuccess extends CreatePostState {
  const CreatePostSuccess();
}

/// Emitted if validation or the database network request encounters an issue.
class CreatePostFailure extends CreatePostState {
  final String errorMessage;

  const CreatePostFailure(this.errorMessage);
}
