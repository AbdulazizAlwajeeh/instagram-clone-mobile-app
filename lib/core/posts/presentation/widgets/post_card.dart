import 'package:flutter/material.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_actions.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_content.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_header.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_image.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_comments_section.dart';
import '../../domain/entities/post.dart';

/// Presentation layer container widget that orchestrates a social media post card.
///
/// Implements atomic design patterns by composing smaller decoupled widget components
/// (Header, Image, Actions, Content, Comments) into a singular feed element slot.
class PostCard extends StatelessWidget {
  /// The absolute structural domain post entity details to paint on screen interfaces.
  final Post post;

  /// User action notification callback dispatched upon tapping the like toggle interactive node.
  final VoidCallback onLikeTapped;

  /// User action notification callback dispatched upon tapping the comment layout action item.
  final VoidCallback onCommentTapped;

  /// User action notification callback dispatched upon tapping user profile handles or avatars.
  final VoidCallback onProfileTapped;

  /// Creates a unified [PostCard] layout view container.
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
        // 1. Author Identity Bar
        PostCardHeader(
          username: post.author.username,
          userAvatarUrl: post.author.avatarUrl,
          onProfileTapped: onProfileTapped,
        ),
        // 2. Main Media Viewer Canvas
        PostCardImage(imageUrl: post.mediaUrl),
        // 3. Contextual Icon Interaction Strip
        PostCardActions(
          isLiked: post.isLiked,
          onLikeTapped: onLikeTapped,
          onCommentTapped: onCommentTapped,
        ),
        // 4. Metrics & Textual Caption Meta Track
        PostCardContent(
          username: post.author.username,
          caption: post.caption ?? '',
          likesCount: post.likesCount,
          timeAgo: '${post.createdAt.hour}:${post.createdAt.minute}',
        ),
        // 5. Lazy-Loaded Preview Bottom Action Bar
        PostCommentSection(
          commentsCount: post.commentsCount,
          onCommentTapped: onCommentTapped,
        ),
      ],
    );
  }
}
