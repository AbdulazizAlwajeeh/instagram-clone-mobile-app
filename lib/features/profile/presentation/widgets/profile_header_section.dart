import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

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
                child: Icon(
                  Icons.person,
                  size: 40.0,
                  color: context.colorScheme.primary,
                ),
              ),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatColumn(count: '142', label: 'Posts'),
                    StatColumn(count: '12.4K', label: 'Followers'),
                    StatColumn(count: '482', label: 'Following'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),

          // Bio Metadata Stack
          Text(
            'Engineering Lead',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'Building distributed systems and reactive user interfaces. Strictly clean architecture frameworks.',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.md),

          // Action Block Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      AppDimensions.minTouchTarget,
                    ),
                    side: BorderSide(
                      color: context.colorScheme.primary.withValues(alpha: 0.5),
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
                      color: context.colorScheme.primary.withValues(alpha: 0.5),
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
