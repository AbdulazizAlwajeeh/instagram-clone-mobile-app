part of 'feed_bloc.dart';

abstract class FeedEvent {
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
  final String postId;

  const FeedPostLikeTapped({required this.postId});
}

/// Fired when a user successfully submits a new comment from the feed sheet.
class FeedCommentSubmitted extends FeedEvent {
  final String postId;
  final String text;

  const FeedCommentSubmitted({required this.postId, required this.text});
}

/// Fired when the user clicks the comments section button on the feed.
class CommentsFetchRequested extends FeedEvent {
  final String postId;

  const CommentsFetchRequested({required this.postId});
}
