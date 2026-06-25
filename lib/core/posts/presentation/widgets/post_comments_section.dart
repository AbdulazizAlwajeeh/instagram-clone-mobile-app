import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/theme_extensions.dart';

class PostCommentSection extends StatelessWidget {
  final int commentsCount;
  final VoidCallback? onCommentTapped;

  const PostCommentSection({
    super.key,
    required this.commentsCount,
    this.onCommentTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCommentTapped,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppDimensions.xs,
          left: AppDimensions.md,
        ),
        child: Text(
          'View all $commentsCount comments',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
