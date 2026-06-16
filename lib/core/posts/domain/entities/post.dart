import 'package:yemengram/core/app_user/domain/entities/app_user.dart';

class Post {
  final String id;
  final AppUser author;
  final String? caption;
  final String mediaUrl;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.author,
    this.caption,
    required this.mediaUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
  });
}
