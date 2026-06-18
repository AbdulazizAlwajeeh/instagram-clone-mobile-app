import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayoutPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayoutPage({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isNotAtHomeTab = navigationShell.currentIndex != 0;

    return PopScope(
      canPop: !isNotAtHomeTab,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (isNotAtHomeTab) {
          navigationShell.goBranch(0, initialLocation: false);
        }
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Post',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
