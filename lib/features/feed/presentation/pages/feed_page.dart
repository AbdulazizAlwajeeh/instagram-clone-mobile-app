import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/posts/presentation/widgets/comment_sheet_content.dart';
import '../../../../core/posts/presentation/widgets/post_card.dart';
import '../bloc/feed_bloc.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _scrollController = ScrollController();
  late final FeedBloc _feedBloc;

  @override
  void initState() {
    super.initState();
    _feedBloc = context.read<FeedBloc>();
    _feedBloc.add(FeedFetchInitialPosts());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      _feedBloc.add(FeedFetchNextPage());
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
    return Scaffold(
      appBar: AppBar(title: const Text('Yemengram'), centerTitle: false),
      body: RefreshIndicator(
        onRefresh: () async {
          _feedBloc.add(FeedRefreshRequested());
          // Wait until the loading status drops to dismiss the spinner smoothly
          await _feedBloc.stream.firstWhere(
            (state) => state.status != FeedStatus.loading,
          );
        },
        child: BlocBuilder<FeedBloc, FeedState>(
          bloc: _feedBloc,
          builder: (context, state) {
            switch (state.status) {
              case FeedStatus.initial:
              case FeedStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case FeedStatus.failure:
                return CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          state.errorMessage.isNotEmpty
                              ? state.errorMessage
                              : 'Failed to load feed.',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                );

              case FeedStatus.success:
                if (state.posts.isEmpty) {
                  return CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: const [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'Your feed is empty. Try following some creators!',
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return _buildListView(state);
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(FeedState state) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
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
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final post = state.posts[index];

        return PostCard(
          post: post,
          onLikeTapped: () {
            _feedBloc.add(FeedPostLikeTapped(postId: post.id));
          },
          onProfileTapped: () {
            context.push('/user/${post.author.id}');
          },
          onCommentTapped: () {
            _feedBloc.add(CommentsFetchRequested(postId: post.id));

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (modalContext) {
                return BlocProvider.value(
                  value: _feedBloc,
                  child: BlocBuilder<FeedBloc, FeedState>(
                    builder: (sheetContext, sheetState) {
                      return CommentSheetContent(
                        comments: sheetState.activeComments,
                        isLoading:
                            sheetState.isFetchingComments ||
                            sheetState.isSubmittingComment,
                        errorMessage:
                            sheetState.errorMessage.isNotEmpty &&
                                sheetState.activeComments.isEmpty
                            ? sheetState.errorMessage
                            : null,
                        onCommentSubmitted: (typedText) {
                          _feedBloc.add(
                            FeedCommentSubmitted(
                              postId: post.id,
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
        );
      },
    );
  }
}
