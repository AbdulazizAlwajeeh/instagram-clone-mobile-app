import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_in_page.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_up_page.dart';
import 'package:yemengram/core/presentation/pages/main_layout.dart';
import 'package:yemengram/features/feed/presentation/pages/feed_page.dart';
import 'package:yemengram/features/search/presentation/pages/search_page.dart';
import 'package:yemengram/features/post/presentation/pages/post_page.dart';
import 'package:yemengram/features/chat/presentation/pages/chat_page.dart';
import 'package:yemengram/features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  // Centralized route name constants to prevent typos across the app
  static const String signInPath = '/sign-in';
  static const String signUpPath = '/sign-up';

  // Tab path constants
  static const String feedPath = '/';
  static const String searchPath = '/search';
  static const String createPostPath = '/create-post';
  static const String chatPath = '/chat';
  static const String profilePath = '/profile';

  // Root navigator key for global context operations if needed
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    // The initial path the application opens to on launch
    initialLocation: signInPath,
    routes: [
      GoRoute(
        path: signInPath,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: signUpPath,
        builder: (context, state) => const SignUpPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayoutPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: feedPath,
                builder: (context, state) => const FeedPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: searchPath,
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: createPostPath,
                builder: (context, state) => const CreatePostPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: chatPath,
                builder: (context, state) => const ChatPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
