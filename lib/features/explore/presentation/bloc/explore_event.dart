part of 'explore_bloc.dart';

/// Base class for all exploration-related actions and events.
sealed class ExploreEvent {
  /// Allows subclasses to have a constant constructor.
  const ExploreEvent();
}

/// Dispatched when the explore screen is first initialized or loaded.
class ExploreFetchRequested extends ExploreEvent {
  /// Creates a [ExploreFetchRequested] event.
  const ExploreFetchRequested();
}

/// Dispatched when the user performs a swipe-to-refresh action on the explore screen.
class ExploreRefreshRequested extends ExploreEvent {
  /// Creates a [ExploreRefreshRequested] event.
  const ExploreRefreshRequested();
}
