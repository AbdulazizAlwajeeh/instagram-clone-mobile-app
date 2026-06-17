import 'package:flutter/material.dart';

class PostCardActions extends StatelessWidget {
  final bool isLiked;
  final VoidCallback? onLikeTapped;
  final VoidCallback? onCommentTapped;
  final VoidCallback? onShareTapped;
  final VoidCallback? onSaveTapped;

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
