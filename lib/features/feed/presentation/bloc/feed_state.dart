part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, success, failure }

class FeedState {
  final FeedStatus status;
  final List<Post> posts;
  final String errorMessage;
  final bool
  hasReachedMax; // Prevents unnecessary network triggers if the database runs out of posts
  final bool isFetchingComments;
  final bool isSubmittingComment;
  final List<Comment> activeComments;

  const FeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.errorMessage = '',
    this.hasReachedMax = false,
    this.isFetchingComments = false,
    this.isSubmittingComment = false,
    this.activeComments = const [],
  });

  FeedState copyWith({
    FeedStatus? status,
    List<Post>? posts,
    String? errorMessage,
    bool? hasReachedMax,
    bool? isFetchingComments,
    bool? isSubmittingComment,
    List<Comment>? activeComments,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingComments: isFetchingComments ?? this.isFetchingComments,
      isSubmittingComment: isSubmittingComment ?? this.isSubmittingComment,
      activeComments: activeComments ?? this.activeComments,
    );
  }
}
