import 'package:yemengram/features/auth/data/models/app_user_model.dart';

import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.author,
    super.caption,
    required super.mediaUrl,
    required super.likesCount,
    required super.commentsCount,
    required super.createdAt,
  });

  /// Factory constructor to create a PostModel from a Supabase JSON map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    final userData = json['profiles'] as Map<String, dynamic>? ?? const {};
    return PostModel(
      id: json['id'] as String,
      author: AppUserModel.fromJson(userData),
      // Can be null
      caption: json['caption'] as String?,
      mediaUrl: json['media_url'] as String,
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      // Supabase returns timestamptz as an ISO 8601 string, so we parse it here
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Efficient constructor for flat post queries without table joins
  factory PostModel.fromFlatJson(Map<String, dynamic> json) {
    final String postAuthorId = json['user_id'] as String;

    return PostModel(
      id: json['id'] as String,
      author: AppUserModel(id: postAuthorId, username: '', email: ''),
      caption: json['caption'] as String?,
      mediaUrl: json['media_url'] as String,
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Method to convert a PostModel back into a Supabase JSON map (useful for inserting data)
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
