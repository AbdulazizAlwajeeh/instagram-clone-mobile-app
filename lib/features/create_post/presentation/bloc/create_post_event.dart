part of 'create_post_bloc.dart';

/// Sealed base class representing all incoming actions for the post creation workflow.
sealed class CreatePostEvent {
  /// Enables constant inheritance across concrete sub-events.
  const CreatePostEvent();
}

/// Fired by the UI widget when the user fills out the text fields and clicks submit.
class PublishPostEvent extends CreatePostEvent {
  /// The descriptive narrative textual commentary written by the post creator.
  final String caption;

  /// The cached local binary asset file pointer targeting upload persistence.
  final File mediaFile;

  /// Bundles mandatory presentation fields required to initiate state transformations.
  const PublishPostEvent({required this.caption, required this.mediaFile});
}
