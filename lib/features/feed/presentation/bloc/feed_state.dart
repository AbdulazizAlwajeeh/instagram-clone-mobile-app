part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, success, failure }

class FeedState {
  final FeedStatus status;
  final List<Post> posts;
  final String errorMessage;
  final bool
  hasReachedMax; // Prevents unnecessary network triggers if the database runs out of posts

  const FeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.errorMessage = '',
    this.hasReachedMax = false,
  });

  FeedState copyWith({
    FeedStatus? status,
    List<Post>? posts,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
