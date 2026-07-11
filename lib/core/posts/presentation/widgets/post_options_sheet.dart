import 'package:flutter/material.dart';

import '../../../theme/theme_extensions.dart';

/// A domain-agnostic configuration model representing a single interactive row
/// within the contextual options menu.
///
/// Decouples the presentation sheet from specific business features by
/// abstracting visual traits (title, icon, coloring) and execution behaviors.
class PostOptionItem {
  /// The structural label text rendered inside the menu item slot.
  final String title;

  /// The graphic visual anchor character identifier displayed to the left of the title.
  final IconData icon;

  /// Optional aesthetic modifier to adjust the item label and icon colors
  /// (e.g., crimson/red tints for destructive deletions or reports).
  final Color? color;

  /// Structural execution block triggered upon interacting with this menu entity slot.
  final VoidCallback onTap;

  /// Flag to determine if this option is clickable or greyed out
  final bool isEnabled;

  /// Generates an immutable [PostOptionItem] layout tuple instance.
  const PostOptionItem({
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
    this.isEnabled = true,
  });
}

/// Presentation layer atom widget that acts as a polymorphic contextual utility menu sheet.
///
/// Implements loose coupling paradigms by serving as a generic container that dynamically
/// paints rows from a list of supplied [PostOptionItem] elements. This allows the widget
/// to scale across various usage workflows (e.g., viewing an author's own post actions
/// vs. viewing a peer's reporting options) without modifications to its layout structure.
class PostOptionsSheet extends StatelessWidget {
  /// The collection of dynamic functional menu configuration blocks to draw inside the layout body.
  final List<PostOptionItem> options;

  /// Creates a standardized, highly reusable [PostOptionsSheet] bottom modal anchor framework.
  const PostOptionsSheet({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      // Implements premium UI standards with explicit top-radius boundary framing
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // Ensures the bottom canvas dynamically scales to hug only its structural children elements
        children: [
          // Visual Draggable Handle Bar Anchor
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Polymorphic Option List Generator Slot
          ...options.map((option) {
            // Falls back to the theme's default onSurface text color if no custom option color is supplied
            final Color baseColor =
                option.color ?? context.colorScheme.onSurface;

            // Applies the transparent alpha modifier only if the item is disabled
            final Color finalColor = option.isEnabled
                ? baseColor
                : baseColor.withValues(alpha: 0.35);
            return ListTile(
              leading: Icon(option.icon, color: finalColor),
              title: Text(option.title, style: TextStyle(color: finalColor)),
              onTap: () {
                // Guard check: Do completely nothing if the button is disabled
                if (!option.isEnabled) return;
                // First close the active contextual dialog safely to prevent overlay memory leaks
                Navigator.pop(context);
                // Next, defer action payload execution back up to the coordinating orchestration scope
                option.onTap();
              },
            );
          }),

          const Divider(),

          // Static Safe Dismissive Element Node
          ListTile(
            title: Text(
              'Cancel',
              style: TextStyle(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            leading: Icon(
              Icons.close,
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
