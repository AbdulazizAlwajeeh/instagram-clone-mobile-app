import 'package:flutter/material.dart';
import '../../../../core/posts/presentation/widgets/post_card.dart';

/// A pure presentation shell that remains agnostic of state-management tools.
class ViewPostPage extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final dynamic post;
  final Future<void> Function() onRefresh;
  final VoidCallback? onLikeTapped;
  final VoidCallback? onCommentTapped;
  final VoidCallback? onShareTapped;
  final VoidCallback? onSaveTapped;

  const ViewPostPage({
    super.key,
    required this.isLoading,
    this.errorMessage,
    this.post,
    required this.onRefresh,
    this.onLikeTapped,
    this.onCommentTapped,
    this.onShareTapped,
    this.onSaveTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post'), centerTitle: true),
      body: RefreshIndicator(onRefresh: onRefresh, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      );
    }

    if (post == null) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: const [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('This post no longer exists.')),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: PostCard(
        username: post.author.username,
        userAvatarUrl: post.author.avatarUrl,
        postImageUrl: post.mediaUrl,
        caption: post.caption ?? '',
        likesCount: post.likesCount ?? 0,
        isLiked: post.isLiked,
        timeAgo: '${post.createdAt.hour}:${post.createdAt.minute}',
        onProfileTapped: () {},
        // Handled locally or exposed if needed
        onLikeTapped: onLikeTapped ?? () {},
        onCommentTapped: onCommentTapped ?? () {},
        onShareTapped: onShareTapped ?? () {},
        onSaveTapped: onSaveTapped ?? () {},
      ),
    );
  }
}
