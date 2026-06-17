import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/posts/presentation/widgets/post_card.dart';
import '../bloc/feed_bloc.dart';

class FeedPage extends StatefulWidget {
  final FeedBloc feedBloc;

  const FeedPage({super.key, required this.feedBloc});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.feedBloc.add(FeedFetchInitialPosts());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      widget.feedBloc.add(FeedFetchNextPage());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedBloc>(
      create: (_) => widget.feedBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Yemengram'), centerTitle: false),
        body: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            switch (state.status) {
              case FeedStatus.initial:
              case FeedStatus.loading:
                // Show a centered loading wheel for the initial page load
                return const Center(child: CircularProgressIndicator());

              case FeedStatus.failure:
                return Center(
                  child: Text(
                    state.errorMessage.isNotEmpty
                        ? state.errorMessage
                        : 'Failed to load feed.',
                    style: const TextStyle(color: Colors.red),
                  ),
                );

              case FeedStatus.success:
                if (state.posts.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your feed is empty. Try following some creators!',
                    ),
                  );
                }

                return RefreshIndicator(
                  // Handles standard pull-to-refresh behavior gracefully
                  onRefresh: () async {
                    widget.feedBloc.add(FeedFetchInitialPosts());
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    // If we haven't reached the max, add 1 extra item slot for the loading spinner at the bottom
                    itemCount: state.hasReachedMax
                        ? state.posts.length
                        : state.posts.length + 1,
                    itemBuilder: (context, index) {
                      // Render the bottom progress spinner if we are at the trailing index slot
                      if (index >= state.posts.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }

                      final post = state.posts[index];

                      return PostCard(
                        username: post.author.username,
                        userAvatarUrl: post.author.avatarUrl,
                        postImageUrl: post.mediaUrl,
                        caption: post.caption ?? '',
                        likesCount: 0,
                        isLiked: false,
                        timeAgo:
                            '${post.createdAt.hour}:${post.createdAt.minute}',
                        onProfileTapped: () {},
                        onLikeTapped: () {},
                        onCommentTapped: () {},
                        onShareTapped: () {},
                        onSaveTapped: () {},
                      );
                    },
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
