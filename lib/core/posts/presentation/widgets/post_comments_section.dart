import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/theme_extensions.dart';

/// Presentation layer atom widget rendering the comment preview bar of a post card.
///
/// Acts as a lazy button trigger that displays total message counters and wraps
/// interactive taps to pop up conversational overlay sheets.
class PostCommentSection extends StatelessWidget {
  /// The total quantity of user comment entries compiled underneath the post model.
  final int commentsCount;

  /// Notification callback triggered when a user taps this bottom text preview shortcut bar.
  final VoidCallback? onCommentTapped;

  /// Creates a unified [PostCommentSection] interaction track link.
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
        // Interactive label showcasing real-time comment metrics
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
