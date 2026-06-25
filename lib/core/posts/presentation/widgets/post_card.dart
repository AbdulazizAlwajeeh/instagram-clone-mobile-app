import 'package:flutter/material.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_actions.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_content.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_header.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_image.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_comments_section.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLikeTapped;
  final VoidCallback onCommentTapped;
  final VoidCallback onProfileTapped;

  const PostCard({
    super.key,
    required this.post,
    required this.onLikeTapped,
    required this.onCommentTapped,
    required this.onProfileTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostCardHeader(
          username: post.author.username,
          userAvatarUrl: post.author.avatarUrl,
          onProfileTapped: onProfileTapped,
        ),
        PostCardImage(imageUrl: post.mediaUrl),
        PostCardActions(
          isLiked: post.isLiked,
          onLikeTapped: onLikeTapped,
          onCommentTapped: onCommentTapped,
        ),
        PostCardContent(
          username: post.author.username,
          caption: post.caption ?? '',
          likesCount: post.likesCount,
          timeAgo: '${post.createdAt.hour}:${post.createdAt.minute}',
        ),
        PostCommentSection(
          commentsCount: post.commentsCount,
          onCommentTapped: onCommentTapped,
        ),
      ],
    );
  }
}
