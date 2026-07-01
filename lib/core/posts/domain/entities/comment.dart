/// Core domain entity representing a user comment on a post.
///
/// This class encapsulates the pure business data for a single comment entry,
/// keeping the domain layer decoupled from any database or network drivers.
class Comment {
  /// Unique identifier key for the comment record.
  final String id;

  /// The unique identifier of the target post this comment belongs to.
  final String postId;

  /// The unique identifier of the user who authored this comment.
  final String userId;

  /// The public display name of the comment author.
  final String username;

  /// The remote URL pointing to the comment author's profile image.
  ///
  /// Can be an empty string if the user has no avatar set.
  final String avatarUrl;

  /// The literal textual content of the message body.
  final String text;

  /// The timestamp string recording exactly when the comment was published.
  final String createdAt;

  /// Creates an immutable [Comment] domain entity instance
  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.text,
    required this.createdAt,
  });
}
