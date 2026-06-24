import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yemengram/features/profile/presentation/bloc/profile_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/profile_post_grid.dart';
import '../widgets/profile_tab_delegate.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return state is ProfileLoadSuccess
                ? Text(state.profile.username)
                : Text('');
          },
        ),
        centerTitle: false,
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadSuccess &&
                  state.isMe &&
                  GoRouterState.of(context).matchedLocation ==
                      AppRouter.profilePath) {
                return IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: 'Open Settings',
                  onPressed: () => context.go(AppRouter.settingsFullPath),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoadFailure) {
            return Center(child: Text(state.errorMessage));
          }
          if (state is ProfileLoadSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(
                  ProfileRefreshRequested(userId: state.profile.id),
                );
                await context.read<ProfileBloc>().stream.firstWhere(
                  (state) => state is! ProfileLoading,
                );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // 1. Profile Header Elements (Avatar, Metrics, Bio, Buttons)
                  SliverToBoxAdapter(
                    child: ProfileHeaderSection(
                      profile: state.profile,
                      isMe: state.isMe,
                      onEditPressed: () async {
                        final profileUpdated = await context.push<bool>(
                          AppRouter.editProfileFullPath,
                          extra: state.profile,
                        );
                        if (profileUpdated == true && context.mounted) {
                          context.read<ProfileBloc>().add(
                            const ProfileRefreshRequested(userId: null),
                          );
                        }
                      },
                      onFollowPressed: () {
                        context.read<ProfileBloc>().add(
                          ProfileFollowToggleRequested(
                            targetUserId: state.profile.id,
                          ),
                        );
                      },
                    ),
                  ),

                  // 2. Pinned Layout Tab Bar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: ProfileTabDelegate(),
                  ),

                  // 3. Aspect-Locked Post Grid Stub
                  ProfilePostGrid(posts: state.posts),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
