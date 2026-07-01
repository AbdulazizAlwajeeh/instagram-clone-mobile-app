import 'package:flutter/material.dart';

/// Presentation layer atom widget rendering the interactive utility action row of a post card.
///
/// Houses interactive button controls responsible for modifying post states (likes, bookmarks)
/// and calling transactional modal popups or external share extensions.
class PostCardActions extends StatelessWidget {
  /// Flag identifying if the currently authenticated user account has liked this post asset.
  final bool isLiked;

  /// Notification callback triggered when the user taps on the favorite/like icon button.
  final VoidCallback? onLikeTapped;

  /// Notification callback triggered when the user clicks the speech bubble/comment button.
  final VoidCallback? onCommentTapped;

  /// Notification callback triggered when the user initiates a system share event.
  final VoidCallback? onShareTapped;

  /// Notification callback triggered when the user toggles the local bookmark/save state.
  final VoidCallback? onSaveTapped;

  /// Creates a standardized [PostCardActions] horizontal interactive row block instance.
  const PostCardActions({
    super.key,
    required this.isLiked,
    this.onLikeTapped,
    this.onCommentTapped,
    this.onShareTapped,
    this.onSaveTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : null,
          ),
          onPressed: onLikeTapped,
        ),
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          onPressed: onCommentTapped,
        ),
        IconButton(
          icon: const Icon(Icons.send_outlined),
          onPressed: onShareTapped,
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: onSaveTapped,
        ),
      ],
    );
  }
}
