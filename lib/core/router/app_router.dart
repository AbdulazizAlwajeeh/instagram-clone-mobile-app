import 'package:go_router/go_router.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_in_page.dart';

class AppRouter {
  // Centralized route name constants to prevent typos across the app
  static const String signInPath = '/sign-in';
  static const String signUpPath = '/sign-up';

  static final GoRouter router = GoRouter(
    // The initial path the application opens to on launch
    initialLocation: signInPath,
    routes: [
      GoRoute(
        path: signInPath,
        builder: (context, state) => const SignInPage(),
      ),
    ],
  );
}
