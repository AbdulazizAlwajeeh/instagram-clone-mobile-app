import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yemengram/core/theme/theme_extensions.dart';
import '../../../../core/posts/presentation/widgets/post_card.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../bloc/post_details_bloc.dart';
import '../bloc/post_details_event.dart';
import '../bloc/post_details_state.dart';
import '../widgets/comment_sheet_content.dart';
import '../widgets/post_options_sheet.dart';

/// Presentation layer screen widget that renders a detailed view of a single post.
///
/// Coordinates pulling fresh data via [RefreshIndicator], pattern-matches the active
/// bloc state to handle screen states, and opens the comments workflow sheet.
class ViewPostPage extends StatelessWidget {
  /// The distinct identification key of the target post to display.
  final String postId;

  /// Creates a [ViewPostPage] screen widget instance.
  const ViewPostPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PostDetailBloc>();

    return BlocListener<PostDetailBloc, PostDetailState>(
      // 1. Intercept states that cause non-visual side effects (snackbars, navigation)
      listenWhen: (previous, current) =>
          current is ReportingPostFailure || current is ReportingPostSuccess,
      listener: (context, state) {
        if (state is ReportingPostFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is ReportingPostSuccess && state.post != null) {
          try {
            final postEntity = state.post as Post;
            // If the post was successfully reported, notify user and pop out of the screen
            if (postEntity.reportedByMe) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post successfully reported.'),
                  backgroundColor: Colors.green,
                ),
              );
              // Safely pop the user back to the underlying Explore or Profile Grid view
              context.pop();
            }
          } catch (_) {}
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Post'), centerTitle: true),
        body: RefreshIndicator(
          onRefresh: () async {
            bloc.add(PostDetailRefreshRequested(postId: postId));
            // Wait smoothly until the state transitions out of loading status
            await bloc.stream.firstWhere(
              (state) => state is! PostDetailLoading,
            );
          },
          child: BlocBuilder<PostDetailBloc, PostDetailState>(
            builder: (context, state) {
              // Extract the active post instance across states using pattern matching.
              final currentPost = switch (state) {
                PostDetailInitial() => null,
                PostDetailLoading(post: final p) => p,
                PostDetailSuccess(post: final p) => p,
                PostDetailFailure(post: final p) => p,
                ReportingPostInProgress(post: final p) => p,
                ReportingPostFailure(post: final p) => p,
                ReportingPostSuccess(post: final p) => p,
              };

              // 1. Handle Fullscreen Loading State
              if (state is PostDetailLoading && currentPost == null) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2. Handle Failure State
              if (state is PostDetailFailure && currentPost == null) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          state.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                );
              }

              // 3. Handle Missing Post State
              if (currentPost == null) {
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

              // 4. Render Active Post Layout
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: PostCard(
                  post: currentPost,
                  onMoreTapped: () {
                    showModalBottomSheet(
                      context: context,
                      // Allows rounded corners to show
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (modalContext) {
                        // Check if this post has already been processed by the user
                        final bool hasBeenReported = currentPost.reportedByMe;
                        return PostOptionsSheet(
                          options: [
                            // Option 1: Report Post
                            PostOptionItem(
                              title: 'Report Post',
                              icon: Icons.report_problem_outlined,
                              color: context.colorScheme.error,
                              isEnabled: !hasBeenReported,
                              onTap: () {
                                bloc.add(PostReportSubmitted(postId: postId));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onLikeTapped: () {
                    context.read<PostDetailBloc>().add(
                      PostDetailLikeTapped(postId: currentPost.id),
                    );
                  },
                  onProfileTapped: () {
                    // 1. Get the current active path (e.g. '/explore/post/123'
                    final currentLocation = GoRouterState.of(
                      context,
                    ).matchedLocation;
                    // 2. Find where the sub-route starts to cut it off
                    final postIndex = currentLocation.indexOf('/post/');
                    // 3. Keep only the base parent tab (e.g. '/explore' or '/feed')
                    final String baseTabPath = postIndex != -1
                        ? currentLocation.substring(0, postIndex)
                        : '';
                    // 4. Push the profile view on top of the current tab
                    context.push('$baseTabPath/user/${currentPost.author.id}');
                  },
                  onCommentTapped: () {
                    // Trigger fetch before opening sheet
                    final postDetailBloc = context.read<PostDetailBloc>();
                    postDetailBloc.add(
                      PostDetailCommentsFetchRequested(postId: currentPost.id),
                    );

                    // Open sheet from the screen level, passing the screen's context
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (modalContext) {
                        return BlocProvider.value(
                          value: postDetailBloc,
                          child: BlocBuilder<PostDetailBloc, PostDetailState>(
                            builder: (modalContext, state) {
                              final List<Comment> fetchedComments =
                                  switch (state) {
                                    PostDetailInitial() => const [],
                                    PostDetailLoading() => state.comments,
                                    PostDetailSuccess() => state.comments,
                                    PostDetailFailure() => state.comments,
                                    ReportingPostInProgress() => state.comments,
                                    ReportingPostFailure() => state.comments,
                                    ReportingPostSuccess() => state.comments,
                                  };

                              return CommentSheetContent(
                                comments: fetchedComments,
                                isLoading: state is PostDetailLoading,
                                errorMessage: state is PostDetailFailure
                                    ? state.errorMessage
                                    : null,
                                onCommentSubmitted: (typedText) {
                                  postDetailBloc.add(
                                    PostDetailCommentSubmitted(
                                      postId: postId,
                                      text: typedText,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
