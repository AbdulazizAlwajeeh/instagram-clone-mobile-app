import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A structural root layout wrapper that manages persistent bottom navigation.
///
/// It utilizes [StatefulNavigationShell] to preserve the state of parallel branch navigation stacks
/// while facilitating structured system back-navigation interception behaviors.
class MainLayoutPage extends StatelessWidget {
  /// The shell interface housing state tracks and routing branch managers for each navigation tab.
  final StatefulNavigationShell navigationShell;

  /// Creates a unified host shell wrapper containing the active nested [navigationShell].
  const MainLayoutPage({super.key, required this.navigationShell});

  /// Handles internal structural tab transitions via the core go_router sequence.
  ///
  /// Triggers a reset flag to drop back to the absolute branch root if the target tab index
  /// matches the active runtime [navigationShell.currentIndex].
  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Evaluates if the current localized branch point deviates from the primary homepage route anchor.
    final bool isNotAtHomeTab = navigationShell.currentIndex != 0;

    return PopScope(
      canPop: !isNotAtHomeTab, // Allows system pop only when the user is
      // explicitly on the initial homepage tab.
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return; // Immediate exit if the pop sequence
        // successfully processed at system level.

        if (isNotAtHomeTab) {
          // Re-routes user back to the default home screen branch before allowing complete exit frames.
          navigationShell.goBranch(0, initialLocation: false);
        }
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
          // Disables shifting animations for flat consistent sizing profiles.
          type: BottomNavigationBarType.fixed,
          // Hides label text elements to enforce a minimalist aesthetic layout.
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
