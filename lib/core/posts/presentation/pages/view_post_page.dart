import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/posts/presentation/widgets/post_card.dart';
import '../bloc/post_details_bloc.dart';
import '../bloc/post_details_event.dart';
import '../bloc/post_details_state.dart';

/// A pure presentation shell that remains agnostic of state-management tools.
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
            // Your exact switch expression moved inside the feature layout layer
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
              child: PostCard(post: currentPost),
            );
          },
        ),
      ),
    );
  }
}
