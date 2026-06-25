import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/posts/presentation/widgets/post_card.dart';
import '../../domain/entities/comment.dart';
import '../bloc/post_details_bloc.dart';
import '../bloc/post_details_event.dart';
import '../bloc/post_details_state.dart';
import '../widgets/comment_sheet_content.dart';

class ViewPostPage extends StatelessWidget {
  final String postId;

  const ViewPostPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PostDetailBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text('Post'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          bloc.add(PostDetailRefreshRequested(postId: postId));
          // Wait smoothly until the state transitions out of loading status
          await bloc.stream.firstWhere((state) => state is! PostDetailLoading);
        },
        child: BlocBuilder<PostDetailBloc, PostDetailState>(
          builder: (context, state) {
            final currentPost = switch (state) {
              PostDetailInitial() => null,
              PostDetailLoading(post: final p) => p,
              PostDetailSuccess(post: final p) => p,
              PostDetailFailure(post: final p) => p,
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
    );
  }
}
