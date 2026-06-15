import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

class ProfileActions extends StatelessWidget {
  final bool isMe;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSharePressed;
  final VoidCallback? onFollowPressed;
  final VoidCallback? onMessagePressed;

  const ProfileActions({
    super.key,
    required this.isMe,
    this.onEditPressed,
    this.onSharePressed,
    this.onFollowPressed,
    this.onMessagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isMe) ...[
          _ActionButton(label: 'Edit Profile', onPressed: onEditPressed),
          const SizedBox(width: AppDimensions.sm),
          _ActionButton(label: 'Share Profile', onPressed: onSharePressed),
        ] else ...[
          _ActionButton(
            label: 'Follow',
            isPrimary: true,
            onPressed: onFollowPressed,
          ),
          const SizedBox(width: AppDimensions.sm),
          _ActionButton(label: 'Message', onPressed: onMessagePressed),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(AppDimensions.minTouchTarget),
      side: isPrimary
          ? BorderSide.none
          : BorderSide(
              color: context.colorScheme.primary.withValues(alpha: 0.5),
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
      ),
      backgroundColor: isPrimary ? context.colorScheme.primary : null,
      foregroundColor: isPrimary ? context.colorScheme.onPrimary : null,
    );

    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isPrimary ? context.colorScheme.onPrimary : null,
          ),
        ),
      ),
    );
  }
}
