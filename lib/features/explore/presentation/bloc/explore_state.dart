part of 'explore_bloc.dart';

/// Base state class for the explore feature tracking the current state layout.
sealed class ExploreState {
  /// The collection of posts cached or loaded in the current cycle.
  final List<Post>? posts;

  /// Creates an [ExploreState] container with an optional [posts] list.
  const ExploreState({this.posts});
}

/// The initial default state before any data fetching begins.
class ExploreInitial extends ExploreState {
  /// Sets up the initial state with no posts data allocated.
  const ExploreInitial() : super(posts: null);
}

/// Emitted while a remote or local database data fetching transaction is active.
class ExploreLoading extends ExploreState {
  /// Retains previous posts to prevent flickering during loading cycles.
  const ExploreLoading({super.posts});
}

/// Emitted when posts are fetched successfully from the infrastructure layer.
class ExploreSuccess extends ExploreState {
  /// Wraps the loaded post collection into the active UI state.
  const ExploreSuccess({required List<Post> posts}) : super(posts: posts);
}

/// Emitted when an error is caught during data fetching transitions.
class ExploreFailure extends ExploreState {
  /// The readable message string explaining the network or parsing error.
  final String errorMessage;

  /// Creates a failure state with the [errorMessage] and any fallback [posts].
  const ExploreFailure({required this.errorMessage, super.posts});
}
