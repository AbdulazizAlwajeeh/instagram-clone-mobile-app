import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/profile_post_grid.dart';
import '../widgets/profile_tab_delegate.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Open Settings',
            onPressed: () {
              context.go(AppRouter.settingsFullPath);
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Profile Header Elements (Avatar, Metrics, Bio, Buttons)
          const SliverToBoxAdapter(child: ProfileHeaderSection()),

          // 2. Pinned Layout Tab Bar
          SliverPersistentHeader(pinned: true, delegate: ProfileTabDelegate()),

          // 3. Aspect-Locked Post Grid Stub
          const ProfilePostGrid(),
        ],
      ),
    );
  }
}
