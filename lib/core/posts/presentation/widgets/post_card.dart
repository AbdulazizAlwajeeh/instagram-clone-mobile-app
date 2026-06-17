import 'package:flutter/material.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_actions.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_content.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_header.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_image.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String? userAvatarUrl;
  final String postImageUrl;
  final String caption;
  final int likesCount;
  final bool isLiked;
  final String timeAgo;

  // Callbacks for interactions
  final VoidCallback? onProfileTapped;
  final VoidCallback? onLikeTapped;
  final VoidCallback? onCommentTapped;
  final VoidCallback? onShareTapped;
  final VoidCallback? onSaveTapped;

  const PostCard({
    super.key,
    required this.username,
    required this.userAvatarUrl,
    required this.postImageUrl,
    required this.caption,
    required this.likesCount,
    required this.isLiked,
    required this.timeAgo,
    this.onProfileTapped,
    this.onLikeTapped,
    this.onCommentTapped,
    this.onShareTapped,
    this.onSaveTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostCardHeader(
          username: username,
          userAvatarUrl: userAvatarUrl,
          onProfileTapped: onProfileTapped,
        ),
        PostCardImage(imageUrl: postImageUrl),
        PostCardActions(
          isLiked: isLiked,
          onLikeTapped: onLikeTapped,
          onCommentTapped: onCommentTapped,
          onShareTapped: onShareTapped,
          onSaveTapped: onSaveTapped,
        ),
        PostCardContent(
          username: username,
          caption: caption,
          likesCount: likesCount,
          timeAgo: timeAgo,
        ),
      ],
    );
  }
}
