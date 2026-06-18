import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

class MediaPickerPlaceholder extends StatelessWidget {
  final File? selectedImage;
  final void Function(BuildContext context) onTap;

  const MediaPickerPlaceholder({
    super.key,
    required this.onTap,
    required this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
