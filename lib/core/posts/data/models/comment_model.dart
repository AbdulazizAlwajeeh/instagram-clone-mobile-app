import '../../domain/entities/comment.dart';

/// Data model representing a user comment within the data layer.
///
/// Extends the core [Comment] domain entity to provide serialization capabilities
/// (JSON parsing and formatting) required for Supabase operations.
class CommentModel extends Comment {
  /// Creates an immutable instance of [CommentModel].
  const CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.username,
    required super.avatarUrl,
    required super.text,
    required super.createdAt,
  });

  /// Factory constructor to cleanly convert Supabase JSON maps into a structural
  /// [CommentModel] instance.
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String? ?? '',
      // Fallback for safety
      text: json['message'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  /// Serialization method to format the [CommentModel] parameters back into
  /// relational JSON fields suitable for Supabase insertion.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'username': username,
      'avatar_url': avatarUrl,
      'message': text,
      'created_at': createdAt,
    };
  }
}
