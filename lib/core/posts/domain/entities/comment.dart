class Comment {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String avatarUrl;
  final String text;
  final String createdAt;

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
