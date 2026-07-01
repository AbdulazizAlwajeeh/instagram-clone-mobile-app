import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
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
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/chat/presentation/pages/texting_page.dart';
import '../../features/explore/presentation/bloc/explore_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../init_dependencies.dart';
import '../posts/presentation/bloc/post_details_bloc.dart';
import '../posts/presentation/bloc/post_details_event.dart';
import '../posts/presentation/pages/view_post_page.dart';

/// Core navigation engine configuring application deep-linking and state-driven route redirections.
///
/// Integrates [GoRouter] structures to coordinate nested branch navigation tabs, modular sub-routes,
/// global redirection middleware using stream listenables, and dependency extraction setups.
class AppRouter {
  /// The global authentication supervisor stream used to evaluate access control layers dynamically.
  final AuthBloc _authBloc;

  /// Creates a primary core router controller bound to the application's active [_authBloc] stream instance.
  AppRouter({required AuthBloc authBloc}) : _authBloc = authBloc;

  // ==========================================
  // Centralized Route Name Constants
  // ==========================================

  /// Global access tracking string path leading directly to the primary user authentication gateway.
  static const String signInPath = '/sign-in';

  /// Global access tracking string path leading directly to the user profile generation platform layout.
  static const String signUpPath = '/sign-up';

  // ==========================================
  // Tab Path Constants
  // ==========================================

  /// Base navigation root directory layout pointing directly to the global activity stream layout.
  static const String feedPath = '/';

  /// Persistent shell branch tracking path pointing directly to the aggregated content index interface.
  static const String explorePath = '/explore';

  /// Persistent shell branch tracking path pointing directly to the local canvas content compilation menu.
  static const String createPostPath = '/create-create_post';

  /// Persistent shell branch tracking path pointing directly to active direct interaction timelines.
  static const String chatPath = '/chat';

  /// Persistent shell branch tracking path pointing directly to the logged-in profile viewport matrix.
  static const String profilePath = '/profile';

  /// Local contextual sub-route path targeted for accessing configuration adjustments parameters.
  static const String editProfilePath = 'edit';

  /// Absolute navigation route address string mapping explicitly to the data modification page layout.
  static const String editProfileFullPath = '/profile/edit';

  /// Parameterized sub-route string identifier used for referencing dedicated text communication threads.
  static const String textingSubPath = 'texting/:chatId';

  /// Unique structural lookup handle utilized by the naming engine for quick page invocations.
  static const String textingName = 'texting';

  // ==========================================
  // Sub-Route Path Constants
  // ==========================================

  /// Relative route node location tracking assigned to application configuration menus.
  static const String settingsPath =
      'settings'; // Relative path (No leading slash)

  /// Absolute root lookup directory path layout pointing to application configuration settings.
  static const String settingsFullPath =
      '/profile/settings'; // Full path for navigation calls

  /// Parameterized relative child reference token mapped to dedicated profile lookup parameters.
  static const String dynamicProfileSubPath = 'user/:userId';

  /// Parameterized relative child reference token mapped to unique standalone content records.
  static const String viewPostSubPath = 'post/:postId';

  /// Formulates an absolute routing directory pattern optimized for nested contextual tracking layers.
  ///
  /// Synthesizes the active target location [currentTab] and target identifier [postId]
  /// to ensure system backward histories match the current tab's pathing strategy.
  static String viewPostFullPath(String currentTab, String postId) {
    if (currentTab == '/') {
      return '/post/$postId'; // Strips redundant slash intersections if triggered directly on the root feed layout.
    }
    return '$currentTab/post/$postId';
  }

  // ==========================================
  // Reusable Shared Route Objects
  // ==========================================

  /// Modular navigation sub-definition processing lookups and display loads for third-party profiles.
  ///
  /// Primes the profile interface context by loading a fresh bounded [ProfileBloc] frame
  /// and automatically dispatching a lookup event matching the extracted runtime parameter tracking token.
  GoRoute get userProfileRoute => GoRoute(
    path: dynamicProfileSubPath,
    builder: (context, state) {
      final targetUserId = state.pathParameters['userId'];
      return BlocProvider(
        create: (context) =>
            serviceLocator<ProfileBloc>()
              ..add(ProfileFetchRequested(userId: targetUserId)),
        // Automatically requests remote record verification on mount.
        child: ProfilePage(
          onPostTapped: (postId) => context.push('/post/$postId'),
          onMessagePressed: (loadedProfile) {
            AppUser user = AppUser(
              id: loadedProfile.id,
              username: loadedProfile.username,
              email: '',
              avatarUrl: loadedProfile.avatarUrl,
            );
            context.pushNamed(
              AppRouter.textingName,
              pathParameters: {'chatId': 'new'},
              // Signals the target page layout to configure a cold start chat canvas frame.
              extra: user,
            );
          },
        ),
      );
    },
  );

  /// Modular navigation sub-definition processing metadata gathering for unique data records.
  ///
  /// Extracts the required parameter identifier keys out of active route frames and injects
  /// an initialized [PostDetailBloc] controller block into the resulting view tree node.
  GoRoute get viewPostRoute => GoRoute(
    path: viewPostSubPath,
    builder: (context, state) {
      final postId = state.pathParameters['postId']!;

      return BlocProvider<PostDetailBloc>(
        create: (context) =>
            serviceLocator<PostDetailBloc>()
              ..add(PostDetailFetchRequested(postId: postId)),
        // Automatically pulls post layout state parameters.
        child: ViewPostPage(postId: postId),
      );
    },
  );

  /// Modular navigation sub-definition processing message streaming inside communication windows.
  ///
  /// Extracts string target indices alongside [AppUser] domain object payloads
  /// handed over inside the navigation state metadata track parameter.
  GoRoute get textingRoute => GoRoute(
    path: textingSubPath,
    name: textingName,
    builder: (context, state) {
      final chatId = state.pathParameters['chatId']!;
      final targetUser =
          state.extra
              as AppUser; // Pulls down the structural model directly from navigation transition steps.

      return BlocProvider<ChatBloc>(
        create: (context) => serviceLocator<ChatBloc>(),
        child: TextingPage(targetUser: targetUser, chatId: chatId),
      );
    },
  );

  // ==========================================
  // Router Setup and Middlewares
  // ==========================================

  /// Global structural anchor reference utilized for handling dialog overlays or top-tier context lookups.
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Core unmodifiable engine configuration mapping out global routes, loops, boundaries, and middleware parameters.
  late final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: signInPath,
    // Redirects app engine explicitly to cold boot gate layout.
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    // Re-evaluates routing boundaries whenever session tokens shift.
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = _authBloc.state is AuthSuccess;

      // Evaluates whether the current tracking trajectory points directly inside security credential barriers.
      final isAtAuthPage =
          state.matchedLocation == signInPath ||
          state.matchedLocation == signUpPath;

      // 1. Enforces gate redirection conditions if the current session remains unauthorized.
      if (!loggedIn) {
        // Blocks entry to underlying system dashboard files while maintaining current pathing options inside security walls.
        return isAtAuthPage ? null : signInPath;
      }

      // 2. Enforces forward trajectory loops if authorization validations evaluate successfully.
      if (isAtAuthPage) {
        // Deflects authenticated profiles away from access portals directly into core production streams.
        return feedPath;
      }

      // Default state clear. Allows traffic trajectories to navigate to intended destination models unhindered.
      return null;
    },
    routes: [
      /// Open authentication access node mapped directly to the sign-in layout interface.
      GoRoute(
        path: signInPath,
        builder: (context, state) => const SignInPage(),
      ),

      /// Open authentication access node mapped directly to the sign-up layout interface.
      GoRoute(
        path: signUpPath,
        builder: (context, state) => const SignUpPage(),
      ),

      /// Structural concurrent branch layout wrapper configuring the persistent tab state machines.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Encapsulates the application's global structural shell view layout frame.
          return MainLayoutPage(navigationShell: navigationShell);
        },
        branches: [
          // ==========================================
          // Tab Branch 1: Feed (Index 0)
          // ==========================================
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: feedPath,
                builder: (context, state) {
                  return BlocProvider<FeedBloc>(
                    create: (context) => serviceLocator<FeedBloc>(),
                    child: FeedPage(
                      onProfileTapped: (userId) => context.push(
                        '/user/$userId',
                      ), // Pushes the sub-profile context without breaking the root shell tracking.
                    ),
                  );
                },
                routes: [
                  userProfileRoute,
                  viewPostRoute,
                ], // Injects structural child nodes under this localized stack layout.
              ),
            ],
          ),

          // ==========================================
          // Tab Branch 2: Explore (Index 1)
          // ==========================================
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: explorePath,
                builder: (context, state) {
                  return BlocProvider<ExploreBloc>(
                    create: (context) =>
                        serviceLocator<ExploreBloc>()
                          ..add(const ExploreFetchRequested()),
                    // Immediately initializes catalog compilation streams on mount.
                    child: const ExplorePage(),
                  );
                },
                routes: [
                  userProfileRoute,
                  viewPostRoute,
                ], // Mirrors shared exploration details routes inside this standalone shell.
              ),
            ],
          ),

          // ==========================================
          // Tab Branch 3: Create Post (Index 2)
          // ==========================================
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

          // ==========================================
          // Tab Branch 4: Chat (Index 3)
          // ==========================================
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: chatPath,
                builder: (context, state) => BlocProvider<ChatBloc>(
                  create: (context) => serviceLocator<ChatBloc>(),
                  child: ChatPage(
                    onChatSelected: (chatId, otherUser) {
                      // Uses explicit goNamed path execution targets to parse direct parameters securely.
                      context.goNamed(
                        AppRouter.textingName,
                        pathParameters: {'chatId': chatId},
                        extra: otherUser,
                      );
                    },
                  ),
                ),
                routes: [
                  userProfileRoute,
                  textingRoute,
                ], // Appends deep messaging interaction lines down this branch layout tree.
              ),
            ],
          ),

          // ==========================================
          // Tab Branch 5: Profile (Index 4)
          // ==========================================
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      serviceLocator<ProfileBloc>()
                        ..add(const ProfileFetchRequested(userId: null)),
                  // Passing null tells the system to query the authenticated user profile.
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

                  // --- Sub-Route: Edit Profile ---
                  GoRoute(
                    path: editProfilePath,
                    builder: (context, state) => BlocProvider<EditProfileBloc>(
                      create: (context) => serviceLocator<EditProfileBloc>(),
                      child: EditProfilePage(
                        user: state.extra as UserProfile,
                      ), // Explicitly unpacks structural profile payload.
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

  /// Public accessor mapping out the configured [GoRouter] pipeline configuration framework.
  GoRouter get config => router;
}

/// A custom utility subscription bridge converting system streams into [ChangeNotifier] frames.
///
/// Intercepts stream notifications and converts them into standard listenable signals,
/// forcing [GoRouter] to re-evaluate structural redirection pipelines immediately.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Local streaming interface connection tracking block.
  late final StreamSubscription<dynamic> _subscription;

  /// Establishes an active stream monitor that triggers data change events upon every data delivery loop.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    ); // Dispatches update alerts upstream.
  }

  @override
  void dispose() {
    _subscription
        .cancel(); // Completely kills internal streaming handles to prevent memory leak states.
    super.dispose();
  }
}
