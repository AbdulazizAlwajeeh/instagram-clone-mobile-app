import 'package:flutter/material.dart';
import 'package:yemengram/core/localization/extensions/localization_extensions.dart';
import '../../../../core/theme/theme_extensions.dart';

class ProfileStats extends StatelessWidget {
  final int postsCount;
  final int followersCount;
  final int followingCount;

  const ProfileStats({
    super.key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          count: postsCount.toString(),
          label: context.l10n.profilePostsCounter,
        ),
        _StatItem(
          count: followersCount.toString(),
          label: context.l10n.profileFollowersCounter,
        ),
        _StatItem(
          count: followingCount.toString(),
          label: context.l10n.profileFollowingCounter,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label});

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
