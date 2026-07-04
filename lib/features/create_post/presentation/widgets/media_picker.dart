import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Presentation placeholder box managing media attachment selection visibility.
///
/// Provides an interactive fallback layout containing textual hints and standard
/// material icons when empty, or previews the selected native disk image frame.
class MediaPickerPlaceholder extends StatelessWidget {
  /// The local device platform file reference targeted for render previewing.
  final File? selectedImage;

  /// Trigger click event callback piping layout anchors back into parent views.
  final void Function(BuildContext context) onTap;

  /// Constructs an immutable frame validating asset preview pointers.
  const MediaPickerPlaceholder({
    super.key,
    required this.onTap,
    required this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // Standardize the presentation component dimensions strictly to landscape layouts
      aspectRatio: 16 / 9,
      child: Container(
        color: context.colorScheme.surfaceContainerLowest,
        child: InkWell(
          onTap: () {
            onTap(context);
          },
          child: selectedImage != null
              ? Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48.0,
                      color: context.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      'Tap to upload photos or videos',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
