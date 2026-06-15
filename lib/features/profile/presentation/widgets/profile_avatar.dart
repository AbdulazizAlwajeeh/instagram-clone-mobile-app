import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;

  const ProfileAvatar({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    // Check if the user has a valid profile picture
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return CircleAvatar(
      radius: 44.0,
      backgroundColor: context.colorScheme.primary.withValues(alpha: 0.15),
      backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
      child: !hasAvatar
          ? Icon(Icons.person, size: 40.0, color: context.colorScheme.primary)
          : null,
    );
  }
}
