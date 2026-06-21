part of 'explore_bloc.dart';

sealed class ExploreState {
  final List<Post>? posts;

  const ExploreState({this.posts});
}

class ExploreInitial extends ExploreState {
  const ExploreInitial() : super(posts: null);
}

class ExploreLoading extends ExploreState {
  const ExploreLoading({super.posts});
}

class ExploreSuccess extends ExploreState {
  const ExploreSuccess({required List<Post> posts}) : super(posts: posts);
}

class ExploreFailure extends ExploreState {
  final String errorMessage;

  const ExploreFailure({required this.errorMessage, super.posts});
}
