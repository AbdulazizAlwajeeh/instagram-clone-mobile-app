import 'package:yemengram/core/app_user/domain/entities/app_user.dart';

/// Core domain entity representing a social media post across the application.
///
/// This class holds immutable business data for posts and encapsulates pure
/// domain rules. It remains independent of any database or external packages.
class Post {
  /// Unique identifier key for the post record.
  final String id;

  /// The user profile entity containing data of the account that created the post.
  final AppUser author;

  /// Optional textual description or statement attached to the post media.
  final String? caption;

  /// Storage or remote network URL string pointing to the uploaded image or video file.
  final String mediaUrl;

  /// Total count of active user likes received by this post.
  final int likesCount;

  /// Total count of user comment entries associated under this post.
  final int commentsCount;

  /// The timestamp recording exactly when the post was originally published.
  final DateTime createdAt;

  /// Flag indicating whether the currently authenticated user session has liked this post.
  final bool isLiked;

  /// Flag indicating whether the currently authenticated user session has reported this post.
  ///
  /// Used conditionally across views to filter content out of the Explore tab,
  /// while keeping it visible with warning markers inside the Profile tab.
  final bool reportedByMe;

  /// Creates an immutable [Post] domain entity instance.
  const Post({
    required this.id,
    required this.author,
    this.caption,
    required this.mediaUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.isLiked,
    required this.reportedByMe,
  });

  /// Creates a copy of this [Post] with altered parameters while retaining unmodified values.
  ///
  /// The [caption] field accepts an optional function callback `String? Function()?`.
  /// This structure enables explicitly updating the field value to `null` if required.
  Post copyWith({
    String? id,
    AppUser? author,
    String? Function()? caption,
    String? mediaUrl,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    bool? isLiked,
    bool? reportedByMe,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      // Evaluates function execution to support null values cleanly
      caption: caption != null ? caption() : this.caption,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      reportedByMe: reportedByMe ?? this.reportedByMe,
    );
  }
}
