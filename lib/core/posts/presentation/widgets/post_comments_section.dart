import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/theme_extensions.dart';
import '../bloc/post_details_bloc.dart';
import '../bloc/post_details_event.dart';
import '../bloc/post_details_state.dart';
import '../../domain/entities/comment.dart';
import 'comment_sheet_content.dart';

class PostCommentSection extends StatelessWidget {
  final int commentsCount;
  final VoidCallback? onCommentTapped;

  const PostCommentSection({
    super.key,
    required this.commentsCount,
    this.onCommentTapped,
  });

  static void openSheet(BuildContext context, {required String postId}) {
    final postDetailBloc = context.read<PostDetailBloc>();

    postDetailBloc.add(PostDetailCommentsFetchRequested(postId: postId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return BlocProvider.value(
          value: postDetailBloc,
          child: BlocBuilder<PostDetailBloc, PostDetailState>(
            builder: (context, state) {
              final List<Comment> fetchedComments = switch (state) {
                PostDetailInitial() => const [],
                PostDetailLoading() => state.comments,
                PostDetailSuccess() => state.comments,
                PostDetailFailure() => state.comments,
              };

              return CommentSheetContent(
                comments: fetchedComments,
                isLoading: state is PostDetailLoading,
                errorMessage: state is PostDetailFailure
                    ? state.errorMessage
                    : null,
                onCommentSubmitted: (typedText) {
                  postDetailBloc.add(
                    PostDetailCommentSubmitted(postId: postId, text: typedText),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCommentTapped,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppDimensions.xs,
          left: AppDimensions.md,
        ),
        child: Text(
          'View all $commentsCount comments',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
