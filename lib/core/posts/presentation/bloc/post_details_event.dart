import 'package:meta/meta.dart';

/// Base event class for all presentation interactions within the post detail feature.
///
/// Every event inside this specific feature lifecycle fundamentally targets a
/// specific post item, thereby enforcing an initialization contract with a [postId].
@immutable
sealed class PostDetailEvent {
  /// The specific destination post identifier related to the requested event stream.
  final String postId;

  /// Abstract constant constructor for event parameter mapping immutability.
  const PostDetailEvent(this.postId);
}

/// Dispatched to trigger the initial full remote query for a post's content and metrics.
class PostDetailFetchRequested extends PostDetailEvent {
  /// Creates a fetch event targeting a specific [postId].
  const PostDetailFetchRequested({required String postId}) : super(postId);
}

/// Dispatched during an explicit user pull-to-refresh or data update gesture.
class PostDetailRefreshRequested extends PostDetailEvent {
  /// Creates a refresh event targeting a specific [postId].
  const PostDetailRefreshRequested({required String postId}) : super(postId);
}

/// Dispatched when the user taps on the like/unlike interaction element.
class PostDetailLikeTapped extends PostDetailEvent {
  /// Creates a interaction like event targeting a specific [postId].
  const PostDetailLikeTapped({required String postId}) : super(postId);
}

/// Dispatched to query and isolate the remote comment threads associated with the post.
class PostDetailCommentsFetchRequested extends PostDetailEvent {
  /// Creates a comment feed fetch event targeting a specific [postId].
  const PostDetailCommentsFetchRequested({required String postId})
    : super(postId);
}

/// Dispatched when the user successfully submits a new textual message response feed item.
class PostDetailCommentSubmitted extends PostDetailEvent {
  /// The actual plain-text string message submitted by the user.
  final String text;

  /// Creates a comment submission entry event mapping [text] under a specific [postId].
  const PostDetailCommentSubmitted({required String postId, required this.text})
    : super(postId);
}
