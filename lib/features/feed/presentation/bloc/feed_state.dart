part of 'feed_bloc.dart';

/// Defines the current operational lifecycle state of the feed transaction engine.
enum FeedStatus {
  /// No transactions have started yet.
  initial,

  /// Active remote or local data retrieval is in progress.
  loading,

  /// Active timeline posts loaded successfully.
  success,

  /// An infrastructure transaction error occurred.
  failure,
}

/// Consolidated state object capturing all context variables for the feed layout screen.
class FeedState {
  /// The operational timeline state flag tracking active network connections.
  final FeedStatus status;

  /// The active historical timeline post entities currently displayed in the view.
  final List<Post> posts;

  /// Human-readable error logs generated when transaction pipelines fail.
  final String errorMessage;

  /// Prevents unnecessary network triggers if the database runs out of posts.
  final bool hasReachedMax;

  /// Boolean flag marking an active network call for comment threads.
  final bool isFetchingComments;

  /// Boolean flag tracking active database insertions for user remarks.
  final bool isSubmittingComment;

  /// Active commentary data arrays loaded inside the current contextual view.
  final List<Comment> activeComments;

  /// Creates a [FeedState] instance containing current feature status settings.
  const FeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.errorMessage = '',
    this.hasReachedMax = false,
    this.isFetchingComments = false,
    this.isSubmittingComment = false,
    this.activeComments = const [],
  });

  /// Factory style copy wrapper to safely generate independent immutable state records.
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
