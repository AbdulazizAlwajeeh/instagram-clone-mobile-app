part of 'explore_bloc.dart';

sealed class ExploreEvent {
  const ExploreEvent();
}

class ExploreFetchRequested extends ExploreEvent {
  const ExploreFetchRequested();
}

class ExploreRefreshRequested extends ExploreEvent {
  const ExploreRefreshRequested();
}
