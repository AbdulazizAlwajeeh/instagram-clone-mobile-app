import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/theme_extensions.dart';

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
      body: SafeArea(
        child: Center(
          child: Text(
            'User Profile Screen Stub',
            style: context.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
