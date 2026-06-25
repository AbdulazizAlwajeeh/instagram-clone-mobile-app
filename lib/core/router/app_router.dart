import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_state.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_in_page.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_up_page.dart';
import 'package:yemengram/core/presentation/pages/main_layout.dart';
import 'package:yemengram/features/create_post/presentation/bloc/create_post_bloc.dart';
import 'package:yemengram/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:yemengram/features/feed/presentation/pages/feed_page.dart';
import 'package:yemengram/features/profile/domain/entities/user_profile.dart';
import 'package:yemengram/features/profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:yemengram/features/profile/presentation/bloc/profile_event.dart';
import 'package:yemengram/features/explore/presentation/pages/explore_page'
    '.dart';
import 'package:yemengram/features/create_post/presentation/pages'
    '/create_post_page.dart';
import 'package:yemengram/features/chat/presentation/pages/chat_page.dart';
import 'package:yemengram/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:yemengram/features/profile/presentation/pages/profile_page.dart';
import '../../features/explore/presentation/bloc/explore_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../init_dependencies.dart';
import '../posts/presentation/bloc/post_details_bloc.dart';
import '../posts/presentation/bloc/post_details_event.dart';
import '../posts/presentation/pages/view_post_page.dart';

class AppRouter {
  final AuthBloc _authBloc;

  AppRouter({required AuthBloc authBloc}) : _authBloc = authBloc;

  // Centralized route name constants to prevent typos across the app
  static const String signInPath = '/sign-in';
  static const String signUpPath = '/sign-up';

  // Tab path constants
  static const String feedPath = '/';
  static const String explorePath = '/explore';
  static const String createPostPath = '/create-create_post';
  static const String chatPath = '/chat';
  static const String profilePath = '/profile';
  static const String editProfilePath = 'edit';
  static const String editProfileFullPath = '/profile/edit';

  // Sub-route path constants
  static const String settingsPath =
      'settings'; // Relative path (No leading slash)
  static const String settingsFullPath =
      '/profile/settings'; // Full path for navigation calls

  static const String dynamicProfileSubPath = 'user/:userId';

  static const String viewPostSubPath = 'post/:postId';

  static String viewPostFullPath(String currentTab, String postId) {
    // If called from profile tab, it builds: "/profile/post/123"
    // If called from feed tab, it builds: "/post/123" (since feed path is "/")
    if (currentTab == '/') {
      return '/post/$postId';
    }
    return '$currentTab/post/$postId';
  }

  final userProfileRoute = GoRoute(
    path: dynamicProfileSubPath,
    builder: (context, state) {
      final targetUserId = state.pathParameters['userId'];
      return BlocProvider(
        create: (context) =>
            serviceLocator<ProfileBloc>()
              ..add(ProfileFetchRequested(userId: targetUserId)),
        child: const ProfilePage(),
      );
    },
  );

  GoRoute get viewPostRoute => GoRoute(
    path: viewPostSubPath,
    builder: (context, state) {
      final postId = state.pathParameters['postId']!;

      return BlocProvider<PostDetailBloc>(
        create: (context) =>
            serviceLocator<PostDetailBloc>()
              ..add(PostDetailFetchRequested(postId: postId)),
        child: ViewPostPage(postId: postId),
      );
    },
  );

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

      // Check if the current route is either sign-in or sign-up
      final isAtAuthPage =
          state.matchedLocation == signInPath ||
          state.matchedLocation == signUpPath;

      // 1. If NOT logged in
      if (!loggedIn) {
        // If they are already trying to view sign-in or sign-up, let them stay
        return isAtAuthPage ? null : signInPath;
      }

      // 2. If LOGGED in
      if (isAtAuthPage) {
        // Bounce them to the default main app page if they try to visit login/signup
        return feedPath;
      }

      // Default: Let them go where they intended
      return null;
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
                builder: (context, state) {
                  return BlocProvider<FeedBloc>(
                    create: (context) => serviceLocator<FeedBloc>(),
                    child: const FeedPage(),
                  );
                },
                routes: [userProfileRoute, viewPostRoute],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: explorePath,
                builder: (context, state) {
                  return BlocProvider<ExploreBloc>(
                    create: (context) =>
                        serviceLocator<ExploreBloc>()
                          ..add(const ExploreFetchRequested()),
                    child: const ExplorePage(),
                  );
                },
                routes: [userProfileRoute, viewPostRoute],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: createPostPath,
                builder: (context, state) => BlocProvider(
                  create: (context) => serviceLocator<CreatePostBloc>(),
                  child: const CreatePostPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: chatPath,
                builder: (context, state) => const ChatPage(),
                routes: [userProfileRoute],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      serviceLocator<ProfileBloc>()
                        ..add(const ProfileFetchRequested(userId: null)),
                  child: const ProfilePage(),
                ),
                routes: [
                  viewPostRoute,
                  // --- Sub-Route: Settings ---
                  // Declared as a child of profile so it stays inside the profile tab shell
                  GoRoute(
                    path: settingsPath,
                    builder: (context, state) => const SettingsPage(),
                  ),
                  GoRoute(
                    path: editProfilePath,
                    builder: (context, state) => BlocProvider<EditProfileBloc>(
                      create: (context) => serviceLocator<EditProfileBloc>(),
                      child: EditProfilePage(user: state.extra as UserProfile),
                    ),
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
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
