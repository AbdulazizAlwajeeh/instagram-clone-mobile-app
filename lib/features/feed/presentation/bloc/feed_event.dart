part of 'feed_bloc.dart';

/// Base class for all event actions driven by user interactions within the feed ecosystem.
abstract class FeedEvent {
  /// Allows subclasses to maintain compile-time constant state definitions.
  const FeedEvent();
}

/// Fired on app launch, when entering the feed tab, or during a pull-to-refresh action.
class FeedFetchInitialPosts extends FeedEvent {}

/// Fired automatically by the scroll listener when the user nears the bottom of the screen.
class FeedFetchNextPage extends FeedEvent {}

/// Fired by pull-to-refresh interactions to silently reload the feed entries.
class FeedRefreshRequested extends FeedEvent {}

/// Triggers state update for likes directly in the feed array list.
class FeedPostLikeTapped extends FeedEvent {
  /// The specific post identity target being liked or unliked.
  final String postId;

  /// Creates a [FeedPostLikeTapped] event container mapping target attributes.
  const FeedPostLikeTapped({required this.postId});
}

/// Fired when a user successfully submits a new comment from the feed sheet.
class FeedCommentSubmitted extends FeedEvent {
  /// The unique key defining which post receives the commentary payload.
  final String postId;

  /// The raw content string holding the textual body of the user's message.
  final String text;

  /// Creates a [FeedCommentSubmitted] transaction configuration package.
  const FeedCommentSubmitted({required this.postId, required this.text});
}

/// Fired when the user clicks the comments section button on the feed.
class CommentsFetchRequested extends FeedEvent {
  /// The identifier associated with the thread containing requested commentary items.
  final String postId;

  /// Instantiates parameter keys required to coordinate commentary retrieval workflows.
  const CommentsFetchRequested({required this.postId});
}
