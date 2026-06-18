part of 'create_post_bloc.dart';

sealed class CreatePostEvent {
  const CreatePostEvent();
}

/// Fired by the UI widget when the user fills out the text fields and clicks submit.
class PublishPostEvent extends CreatePostEvent {
  final String caption;
  final File mediaFile;

  const PublishPostEvent({required this.caption, required this.mediaFile});
}
