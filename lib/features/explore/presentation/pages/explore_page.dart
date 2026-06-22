import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yemengram/core/router/app_router.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../bloc/explore_bloc.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ExploreBloc>();

    final blockSurfaceColor = context.colorScheme.brightness == Brightness.dark
        ? const Color(0xFF1E293B) // Slate 800
        : const Color(0xFFE2E8F0); // Slate 200

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. The Search Bar Header Block
            Padding(
              padding: const EdgeInsets.all(AppDimensions.sm),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: blockSurfaceColor,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.xs,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusSm,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 2. Main Content Area Driven dynamically by the local BlocBuilder
            Expanded(
              child: BlocBuilder<ExploreBloc, ExploreState>(
                builder: (context, state) {
                  final currentPosts = switch (state) {
                    ExploreInitial() => null,
                    ExploreLoading(posts: final p) => p,
                    ExploreSuccess(posts: final p) => p,
                    ExploreFailure(posts: final p) => p,
                  };

                  final bool isLoading =
                      state is ExploreInitial ||
                      (state is ExploreLoading && currentPosts == null);
                  final String? errorMessage = state is ExploreFailure
                      ? state.errorMessage
                      : null;

                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (errorMessage != null &&
                      (currentPosts == null || currentPosts.isEmpty)) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.md),
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.colorScheme.error),
                        ),
                      ),
                    );
                  }

                  if (currentPosts == null || currentPosts.isEmpty) {
                    return const Center(
                      child: Text('No posts found for exploration.'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      bloc.add(const ExploreRefreshRequested());
                      // Synchronize stream transitions before dismissing the swipe animation tracker
                      await bloc.stream.firstWhere((s) => s is! ExploreLoading);
                    },
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2.0,
                            crossAxisSpacing: 2.0,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: currentPosts.length,
                      itemBuilder: (context, index) {
                        final post = currentPosts[index];

                        return GestureDetector(
                          onTap: () {
                            context.go(
                              AppRouter.viewPostFullPath(
                                AppRouter.explorePath,
                                post.id,
                              ),
                            );
                          },
                          child: Image.network(
                            post.mediaUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, _, _) =>
                                _buildPlaceholderIcon(context),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Icon(
      Icons.image,
      color: context.colorScheme.primary.withValues(alpha: 0.25),
    );
  }
}
