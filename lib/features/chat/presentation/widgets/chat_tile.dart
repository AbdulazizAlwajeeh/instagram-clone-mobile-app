import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

/// A presentation list tile widget displaying summary information for an active conversation room.
///
/// Adapts its styling dynamically based on unread message counts, emphasizing unread
/// status with bold text layers, highlight colors, and badge indicators.
class ChatTile extends StatelessWidget {
  /// The distinct display handle text identifying the message participant.
  final String username;

  /// The optional remote image location reference token pointing to user media files.
  final String? avatarUrl;

  /// The descriptive snippet preview text of the most recently sent message.
  final String lastMessage;

  /// The formatted human-readable shorthand relative elapsed time description.
  final String timeStamp;

  /// The counter representing the number of messages unread by the current user.
  final int unreadCount;

  /// The execution callback pipeline fired when a user selects this item container.
  final VoidCallback? onTap;

  /// Compiles immutable constraints around profile details and unread metadata configurations.
  const ChatTile({
    super.key,
    required this.username,
    this.avatarUrl,
    required this.lastMessage,
    required this.timeStamp,
    this.unreadCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Evaluate data presence structures directly to determine responsive design adaptations
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;
    final hasUnread = unreadCount > 0;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      leading: CircleAvatar(
        radius: 28.0,
        backgroundColor: context.colorScheme.primary.withValues(alpha: 0.1),
        backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
        child: !hasAvatar
            ? Icon(Icons.person, size: 28.0, color: context.colorScheme.primary)
            : null,
      ),
      title: Text(
        username,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          lastMessage,
          style: context.textTheme.bodyMedium?.copyWith(
            color: hasUnread
                ? context.colorScheme.onSurface
                : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            timeStamp,
            style: context.textTheme.labelSmall?.copyWith(
              color: hasUnread
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (hasUnread) ...[
            const SizedBox(height: 6.0),
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
