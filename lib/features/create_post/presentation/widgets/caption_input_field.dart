import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

class CaptionInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? userAvatarUrl;

  const CaptionInputField({
    super.key,
    required this.controller,
    this.userAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = userAvatarUrl != null && userAvatarUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: context.colorScheme.primary.withValues(alpha: 0.1),
            backgroundImage: hasAvatar ? NetworkImage(userAvatarUrl!) : null,
            child: !hasAvatar
                ? Icon(Icons.person, color: context.colorScheme.primary)
                : null,
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 4,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
