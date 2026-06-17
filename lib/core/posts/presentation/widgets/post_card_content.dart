import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/theme_extensions.dart';

class PostCardContent extends StatelessWidget {
  final String username;
  final String caption;
  final int likesCount;
  final String timeAgo;

  const PostCardContent({
    super.key,
    required this.username,
    required this.caption,
    required this.likesCount,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$likesCount likes',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          RichText(
            text: TextSpan(
              style: context.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$username ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: caption),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            timeAgo.toUpperCase(),
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.7,
              ),
              fontSize: 10.0,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
        ],
      ),
    );
  }
}
