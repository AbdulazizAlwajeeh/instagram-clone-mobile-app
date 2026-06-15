import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_state.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_in_page.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_up_page.dart';
import 'package:yemengram/core/presentation/pages/main_layout.dart';
import 'package:yemengram/features/feed/presentation/pages/feed_page.dart';
import 'package:yemengram/features/search/presentation/pages/search_page.dart';
import 'package:yemengram/features/post/presentation/pages/post_page.dart';
import 'package:yemengram/features/chat/presentation/pages/chat_page.dart';
import 'package:yemengram/features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../init_dependencies.dart';

class AppRouter {
  final AuthBloc _authBloc;

  AppRouter({required AuthBloc authBloc}) : _authBloc = authBloc;

  // Centralized route name constants to prevent typos across the app
  static const String signInPath = '/sign-in';
  static const String signUpPath = '/sign-up';

  // Tab path constants
  static const String feedPath = '/';
  static const String searchPath = '/search';
  static const String createPostPath = '/create-post';
  static const String chatPath = '/chat';
  static const String profilePath = '/profile';

  // Sub-route path constants
  static const String settingsPath =
      'settings'; // Relative path (No leading slash)
  static const String settingsFullPath =
      '/profile/settings'; // Full path for navigation calls

  static const String dynamicProfileSubPath = 'user/:userId';

  // Root navigator key for global context operations if needed
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  late final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    // The initial path the application opens to on launch
    initialLocation: signInPath,
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = _authBloc.state is AuthSuccess;

      return loggedIn ? null : signInPath;
    },
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
                routes: [
                  GoRoute(
                    path: dynamicProfileSubPath,
                    builder: (context, state) {
                      final targetUserId = state.pathParameters['userId'];
                      return ProfilePage(
                        userId: targetUserId,
                        profileBloc: serviceLocator<ProfileBloc>(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: searchPath,
                builder: (context, state) => const SearchPage(),
                routes: [
                  GoRoute(
                    path: dynamicProfileSubPath,
                    builder: (context, state) {
                      final targetUserId = state.pathParameters['userId'];
                      return ProfilePage(
                        userId: targetUserId,
                        profileBloc: serviceLocator<ProfileBloc>(),
                      );
                    },
                  ),
                ],
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
                routes: [
                  GoRoute(
                    path: dynamicProfileSubPath,
                    builder: (context, state) {
                      final targetUserId = state.pathParameters['userId'];
                      return ProfilePage(
                        userId: targetUserId,
                        profileBloc: serviceLocator<ProfileBloc>(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                builder: (context, state) => ProfilePage(
                  userId: null,
                  profileBloc: serviceLocator<ProfileBloc>(),
                ),
                routes: [
                  // --- Sub-Route: Settings ---
                  // Declared as a child of profile so it stays inside the profile tab shell
                  GoRoute(
                    path: settingsPath,
                    builder: (context, state) => const SettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  GoRouter get config => router;
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
