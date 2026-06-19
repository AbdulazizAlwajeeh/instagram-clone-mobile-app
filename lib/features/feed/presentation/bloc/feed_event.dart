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
