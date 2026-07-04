part of 'create_post_bloc.dart';

/// Sealed base class representing all possible states of the post creation flow.
sealed class CreatePostState {
  /// Enables constant inheritance across concrete sub-states.
  const CreatePostState();
}

/// Represents the form widget in its default, resting state.
class CreatePostInitial extends CreatePostState {
  /// Instantiates an immutable instance of the resting initial state.
  const CreatePostInitial();
}

/// Emitted immediately when the submission process kicks off to show a progress loader.
class CreatePostLoading extends CreatePostState {
  /// Instantiates an immutable instance of the active loading state.
  const CreatePostLoading();
}

/// Emitted upon successful server verification. Contains 0 payload.
class CreatePostSuccess extends CreatePostState {
  /// Instantiates an immutable instance of the successful processing completion state.
  const CreatePostSuccess();
}

/// Emitted if validation or the database network request encounters an issue.
class CreatePostFailure extends CreatePostState {
  /// The user-facing error message describing why the request failed.
  final String errorMessage;

  /// Bundles the structural runtime error details into an immutable failure state.
  const CreatePostFailure(this.errorMessage);
}
