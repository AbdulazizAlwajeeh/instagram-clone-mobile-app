import 'package:flutter/material.dart';
import '../../../theme/theme_extensions.dart';

class PostCardImage extends StatelessWidget {
  final String imageUrl;
  final double aspectRatio;

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
