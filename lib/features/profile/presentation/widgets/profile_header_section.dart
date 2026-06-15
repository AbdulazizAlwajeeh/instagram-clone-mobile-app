import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/user_profile.dart';

class ProfileHeaderSection extends StatelessWidget {
  final UserProfile profile;
  final bool isMe;

  const ProfileHeaderSection({
    super.key,
    required this.profile,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metric Profile Row
          Row(
            children: [
              CircleAvatar(
                radius: 44.0,
                backgroundColor: context.colorScheme.primary.withValues(
                  alpha: 0.15,
                ),
                backgroundImage:
                    profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 40.0,
                        color: context.colorScheme.primary,
                      )
                    : null,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatColumn(
                      count: profile.postsCount.toString(),
                      label: 'Posts',
                    ),
                    StatColumn(
                      count: profile.followersCount.toString(),
                      label:
                          'Follow'
                          'ers',
                    ),
                    StatColumn(
                      count: profile.followingCount.toString(),
                      label:
                          'Follow'
                          'ing',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),

          // Bio Metadata Stack
          Text(
            profile.fullName.toString(),
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.xs),
            Text(profile.bio!, style: context.textTheme.bodyMedium),
          ],

          // Action Block Buttons
          Row(
            children: [
              if (isMe) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        AppDimensions.minTouchTarget,
                      ),
                      side: BorderSide(
                        color: context.colorScheme.primary.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusSm,
                        ),
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        AppDimensions.minTouchTarget,
                      ),
                      side: BorderSide(
                        color: context.colorScheme.primary.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusSm,
                        ),
                      ),
                    ),
                    child: Text(
                      'Share Profile',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Visitor Profile Layout Buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: context.colorScheme.onPrimary,
                      minimumSize: const Size.fromHeight(
                        AppDimensions.minTouchTarget,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusSm,
                        ),
                      ),
                    ),
                    child: Text(
                      'Follow',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        AppDimensions.minTouchTarget,
                      ),
                      side: BorderSide(
                        color: context.colorScheme.primary.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusSm,
                        ),
                      ),
                    ),
                    child: Text(
                      'Message',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class StatColumn extends StatelessWidget {
  final String count;
  final String label;

  const StatColumn({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: context.textTheme.labelSmall),
      ],
    );
  }
}
