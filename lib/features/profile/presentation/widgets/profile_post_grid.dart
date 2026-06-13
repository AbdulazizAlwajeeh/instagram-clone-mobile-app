import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';

class ProfilePostGrid extends StatelessWidget {
  const ProfilePostGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final blockSurfaceColor = context.colorScheme.brightness == Brightness.dark
        ? const Color(0xFF1E293B) // Slate 800 (AppColors.surfaceDark)
        : const Color(0xFFE2E8F0); // Slate 200 light contrast

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          color: blockSurfaceColor,
          child: Icon(
            Icons.image,
            color: context.colorScheme.primary.withValues(alpha: 0.25),
          ),
        );
      }, childCount: 18),
    );
  }
}
