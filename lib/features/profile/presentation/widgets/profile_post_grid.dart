import 'package:flutter/material.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';

class ProfilePostGrid extends StatelessWidget {
  final List<Post> posts;

  const ProfilePostGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return GestureDetector(
          onTap: () {},
          child: Image.network(
            posts[index].mediaUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[400],
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white,
                ),
              );
            },
          ),
        );
      }, childCount: posts.length),
    );
  }
}
