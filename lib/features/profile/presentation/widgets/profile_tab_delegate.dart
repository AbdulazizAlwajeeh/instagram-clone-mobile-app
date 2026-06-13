import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';

class ProfileTabDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // The surface fallback color guarantees correct baseline contrast
    final borderSideColor = context.colorScheme.brightness == Brightness.dark
        ? const Color(0xFF334155) // Slate 700 matching theme surface accents
        : const Color(0xFFE2E8F0); // Slate 200

    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Divider(height: 1.0, thickness: 1.0, color: borderSideColor),
          Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.grid_on_outlined),
                  color: context.colorScheme.primary,
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.assignment_ind_outlined),
                  color: context.textTheme.labelSmall?.color?.withValues(
                    alpha: 0.6,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Divider(height: 1.0, thickness: 1.0, color: borderSideColor),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant ProfileTabDelegate oldDelegate) => false;
}
