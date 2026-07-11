import 'package:yemengram/features/auth/data/models/app_user_model.dart';

import '../../domain/entities/post.dart';

/// Data model representing a social media post within the data layer.
///
/// Extends the core [Post] domain entity to provide serialization capabilities
/// (JSON parsing and formatting) required for Supabase communications.
class PostModel extends Post {
  /// Creates a immutable instance of [PostModel].
  const PostModel({
    required super.id,
    required super.author,
    super.caption,
    required super.mediaUrl,
    required super.likesCount,
    required super.commentsCount,
    required super.createdAt,
    required super.isLiked,
    required super.reportedByMe,
  });

  /// Factory constructor to convert a Supabase multi-table join JSON payload
  /// into a structural [PostModel] instance.
  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Extract nested profile data from the relational query join.
    final userData = json['profiles'] as Map<String, dynamic>? ?? const {};

    // Safe evaluation of the nested likes join count array
    final likesList = json['likes'] as List<dynamic>? ?? const [];
    final bool userHasLiked =
        likesList.isNotEmpty &&
        likesList.first['count'] != null &&
        likesList.first['count'] > 0;

    // Safe evaluation: Handle the dynamic list returned by post_reports
    final reportedList = json['reported_by_me'] as List<dynamic>? ?? const [];

    // If the list is not empty, it means this specific user has a report record for this post
    final bool userHasReported = reportedList.isNotEmpty;

    return PostModel(
      id: json['id'] as String,
      author: AppUserModel.fromJson(userData),
      // Can be null if the user posts without a text body.
      caption: json['caption'] as String?,
      mediaUrl: json['media_url'] as String,
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      // Supabase returns timestamptz as an ISO 8601 string, so we parse it here
      createdAt: DateTime.parse(json['created_at'] as String),
      isLiked: userHasLiked,
      reportedByMe: userHasReported,
    );
  }

  /// Specialized factory constructor for mapping flat database rows
  /// that skip complex relational table joins for performance tuning.
  factory PostModel.fromFlatJson(Map<String, dynamic> json) {
    final String postAuthorId = json['user_id'] as String;

    return PostModel(
      id: json['id'] as String,
      // Generates a skeletal user entity when author profiles aren't requested.
      author: AppUserModel(id: postAuthorId, username: '', email: ''),
      caption: json['caption'] as String?,
      mediaUrl: json['media_url'] as String,
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      isLiked: json['is_liked'] ?? false,
      reportedByMe: json['reported_by_me'] as bool? ?? false,
    );
  }

  /// Serialization method to format the [PostModel] fields back into
  /// a raw relational payload suitable for Supabase insertion or updates.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': author.id,
      'caption': caption,
      'media_url': mediaUrl,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
