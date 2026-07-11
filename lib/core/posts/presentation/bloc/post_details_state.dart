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

/// Represents an active background execution timeline for a post report.
///
/// Retains the active datasets to preserve continuous visual rendering
/// while the database insertion request executes asynchronously.
class ReportingPostInProgress extends PostDetailState {
  /// The active post data payload (already optimistically mutated client-side).
  final dynamic post;

  /// The active comment thread data collection.
  final List<Comment> comments;

  /// Creates a transient reporting state instance with continuous cache retention.
  const ReportingPostInProgress(this.post, this.comments);
}

/// Represents a failed report submission timeline.
///
/// Holds the error description alongside the restored post data cache
/// to trigger feedback rollbacks in the presentation layer.
class ReportingPostFailure extends PostDetailState {
  /// The user-friendly error message detailing the reason for execution failure.
  final String errorMessage;

  /// The original post data payload (rolled back to its pre-report status).
  final dynamic post;

  /// The active comment thread data collection preserved during the failure event.
  final List<Comment> comments;

  /// Creates a reporting failure state containing the [errorMessage] and cached content data.
  const ReportingPostFailure(this.errorMessage, this.post, this.comments);
}

/// Represents a finalized, successful post report submission timeline.
///
/// Dispatched strictly upon verified completion of the database report insertion.
/// Signals presentation consumers to trigger structural side effects, such as
/// closing contextual overlay views or routing the user away from the reported node.
class ReportingPostSuccess extends PostDetailState {
  /// The newly mutated post data payload reflecting updated security flags.
  final dynamic post;

  /// The active comment thread data collection preserved during the success event.
  final List<Comment> comments;

  /// Creates a finalized reporting success state containing the updated [post] content data.
  const ReportingPostSuccess(this.post, this.comments);
}
