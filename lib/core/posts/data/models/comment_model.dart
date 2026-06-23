import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.username,
    required super.avatarUrl,
    required super.text,
    required super.createdAt,
  });

  /// Factory constructor to cleanly convert Supabase JSON maps into a model
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String? ?? '', // Fallback for safety
      text: json['message'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  /// Converts the model parameters back into JSON fields for database insertion
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
