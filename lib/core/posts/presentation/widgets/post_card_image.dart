import 'package:flutter/material.dart';
import '../../../theme/theme_extensions.dart';

/// Presentation layer atom widget rendering the main media canvas of a post card.
///
/// Wraps remote network image files inside constrained proportional slots,
/// handling lazy loading calculations and unexpected asset fetch rejections safely.
class PostCardImage extends StatelessWidget {
  /// The destination network source location URL string for the remote image file.
  final String imageUrl;

  /// The proportional relationship between layout width and height dimensions.
  ///
  /// Defaults to `1.0` to render standard square aspect ratio cards.
  final double aspectRatio;

  /// Creates a standard [PostCardImage] canvas canvas layout instance.
  const PostCardImage({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // Visual handler fallback to guard the view grid if asset URLs break
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: context.colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image, size: 40.0),
          );
        },
      ),
    );
  }
}
