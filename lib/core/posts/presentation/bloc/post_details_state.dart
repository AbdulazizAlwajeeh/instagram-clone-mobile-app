import 'package:meta/meta.dart';
import '../../domain/entities/comment.dart';

/// Base state class for tracking post details and comments interactions.
///
/// Subclasses represent the structural presentation milestones of the detail view.
@immutable
sealed class PostDetailState {
  /// Abstract constant constructor for state immutability.
  const PostDetailState();
}

/// Represents the default fallback or uninitialized state of the post details view.
class PostDetailInitial extends PostDetailState {
  /// Creates the initial uninitialized state.
  const PostDetailInitial();
}

/// Represents an active loading timeline (e.g., first bootup, pulling to refresh).
class PostDetailLoading extends PostDetailState {
  /// Retains the existing post dataset to ensure continuous visual presence
  /// during background refreshes or pull-to-refresh actions.
  final dynamic post;

  /// Retains the existing collection of user comment elements during background reloads.
  final List<Comment> comments;

  /// Creates a loading state instance with optional cache retention elements.
  const PostDetailLoading({this.post, this.comments = const []});
}

/// Represents a successfully resolved view containing up-to-date post data and comment feeds.
class PostDetailSuccess extends PostDetailState {
  /// The absolute verified post data payload.
  final dynamic post;

  /// The active historical comment thread data collection retrieved from Supabase.
  final List<Comment> comments;

  /// Creates a successful state wrapped with active [post] and [comments] details.
  const PostDetailSuccess(
    this.post, {
    this.comments =
        const [], // Default to an empty array for clean instantiation.
  });
}

/// Represents a structural breakdown timeline where a remote or local interaction failed.
class PostDetailFailure extends PostDetailState {
  /// The user-facing error message describing why the interaction fell short.
  final String errorMessage;

  /// Retains the previous post data block to avoid sudden UI jarring if a refresh cycle breaks.
  final dynamic post;

  /// Retains the previous user comment elements to keep UI feeds interactive on error timelines.
  final List<Comment> comments;

  /// Creates a descriptive error failure boundary state with active structural data retention.
  const PostDetailFailure(
    this.errorMessage, {
    this.post,
    this.comments = const [],
  });
}
