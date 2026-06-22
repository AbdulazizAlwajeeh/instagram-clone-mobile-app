import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_bloc.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_event.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_actions.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_content.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_header.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_card_image.dart';
import 'package:yemengram/core/posts/presentation/widgets/post_comments_section.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostCardHeader(
          username: post.author.username,
          userAvatarUrl: post.author.avatarUrl,
          onProfileTapped: () {
            // 1. Get the current active path (e.g. '/explore/post/123'
            final currentLocation = GoRouterState.of(context).matchedLocation;
            // 2. Find where the sub-route starts to cut it off
            final postIndex = currentLocation.indexOf('/post/');
            // 3. Keep only the base parent tab (e.g. '/explore' or '/feed')
            final String baseTabPath = postIndex != -1
                ? currentLocation.substring(0, postIndex)
                : '';
            // 4. Push the profile view on top of the current tab
            context.push('$baseTabPath/user/${post.author.id}');
          },
        ),
        PostCardImage(imageUrl: post.mediaUrl),
        PostCardActions(
          isLiked: post.isLiked,
          onLikeTapped: () {
            context.read<PostDetailBloc>().add(
              PostDetailLikeTapped(postId: post.id),
            );
          },
          onCommentTapped: () {
            PostCommentSection.openSheet(context, postId: post.id);
          },
        ),
        PostCardContent(
          username: post.author.username,
          caption: post.caption ?? '',
          likesCount: post.likesCount,
          timeAgo: '${post.createdAt.hour}:${post.createdAt.minute}',
        ),
        PostCommentSection(
          commentsCount: post.commentsCount,
          onCommentTapped: () {
            PostCommentSection.openSheet(context, postId: post.id);
          },
        ),
      ],
    );
  }
}
