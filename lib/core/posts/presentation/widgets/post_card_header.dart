import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/theme_extensions.dart';

/// Presentation layer atom widget rendering the top identity row of a post card.
///
/// Handles displaying the author's avatar profile image, fallback default vector
/// graphics, username text handle, and option overflow action buttons.
class PostCardHeader extends StatelessWidget {
  /// The unique public display handle of the account that authored the post.
  final String username;

  /// Optional remote URL pointing to the author's profile photo.
  final String? userAvatarUrl;

  /// Notification callback triggered when a user taps anywhere on the profile layout slot.
  final VoidCallback? onProfileTapped;

  /// Notification callback triggered when a user clicks the options/more icon button.
  final VoidCallback? onMoreTapped;

  /// Creates a standard [PostCardHeader] layout block instance.
  const PostCardHeader({
    super.key,
    required this.username,
    this.userAvatarUrl,
    this.onProfileTapped,
    this.onMoreTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Condition verification to toggle between cached network files and default vectors
    final hasAvatar = userAvatarUrl != null && userAvatarUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onProfileTapped,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.sm),
        child: Row(
          children: [
            // 1. Author Avatar Container
            CircleAvatar(
              radius: 18.0,
              backgroundColor: context.colorScheme.primary.withValues(
                alpha: 0.1,
              ),
              backgroundImage: hasAvatar ? NetworkImage(userAvatarUrl!) : null,
              child: !hasAvatar
                  ? Icon(
                      Icons.person,
                      size: 18.0,
                      color: context.colorScheme.primary,
                    )
                  : null,
            ),
            const SizedBox(width: AppDimensions.sm),
            // 2. Author Username Label Text
            Text(
              username,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // 3. Overflow Action Option Button
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMoreTapped,
            ),
          ],
        ),
      ),
    );
  }
}
