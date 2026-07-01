import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/theme_extensions.dart';

/// Presentation layer atom widget rendering the metadata block of a post card.
///
/// Houses structural numeric indicators like total public likes, inline rich text layout
/// constraints combining user handles with explicit descriptions, and formatted timelines.
class PostCardContent extends StatelessWidget {
  /// The public display name of the user who published the post asset.
  final String username;

  /// The literal textual description or message attached to the post card.
  final String caption;

  /// The aggregate total count of active user likes received by this post.
  final int likesCount;

  /// A human-readable display string reflecting the duration elapsed since creation.
  final String timeAgo;

  /// Creates a standard [PostCardContent] description metrics block instance.
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
          // 1. Social Engagement Metric Total Display
          Text(
            '$likesCount likes',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          // 2. Cohesive Unified Author Username and Description Text Track
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
          // 3. Normalized Temporal Meta Tracking Tag
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
