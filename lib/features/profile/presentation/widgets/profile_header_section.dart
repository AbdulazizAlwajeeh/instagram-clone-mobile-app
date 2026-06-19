import 'package:flutter/material.dart';
import 'package:yemengram/features/profile/presentation/widgets/profile_actions.dart';
import 'package:yemengram/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:yemengram/features/profile/presentation/widgets/profile_stats.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/user_profile.dart';

class ProfileHeaderSection extends StatelessWidget {
  final UserProfile profile;
  final bool isMe;
  final VoidCallback onFollowPressed;

  const ProfileHeaderSection({
    super.key,
    required this.profile,
    required this.isMe,
    required this.onFollowPressed,
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
              ProfileAvatar(avatarUrl: profile.avatarUrl),
              Expanded(
                child: ProfileStats(
                  postsCount: profile.postsCount,
                  followersCount: profile.followersCount,
                  followingCount: profile.followingCount,
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
          ProfileActions(
            isMe: isMe,
            isFollowing: profile.isFollowing,
            onEditPressed: () {},
            onSharePressed: () {},
            onFollowPressed: onFollowPressed,
            onMessagePressed: () {},
          ),
        ],
      ),
    );
  }
}
