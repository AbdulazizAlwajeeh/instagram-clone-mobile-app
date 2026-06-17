import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/theme_extensions.dart';

class PostCardHeader extends StatelessWidget {
  final String username;
  final String? userAvatarUrl;
  final VoidCallback? onProfileTapped;
  final VoidCallback? onMoreTapped;

  const PostCardHeader({
    super.key,
    required this.username,
    this.userAvatarUrl,
    this.onProfileTapped,
    this.onMoreTapped,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = userAvatarUrl != null && userAvatarUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onProfileTapped,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.sm),
        child: Row(
          children: [
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
            Text(
              username,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMoreTapped ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
