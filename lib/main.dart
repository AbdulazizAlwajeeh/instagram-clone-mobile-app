import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/core/router/app_router.dart';
import 'package:yemengram/core/theme/app_theme.dart';
import 'package:yemengram/core/theme/presentation/bloc/theme_state.dart';
import 'package:yemengram/init_dependencies.dart';
import 'core/app_user/presentation/cubit/current_user_cubit.dart';
import 'core/theme/presentation/bloc/theme_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

// This annotation ensures the Flutter compiler does not delete this function
// during production builds, allowing the native Android system to find it.
@pragma('vm:entry-point')
// This top-level function runs in a completely separate background isolate.
// It wakes up to process incoming data payloads when the app is closed.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // We must re-initialize Firebase inside this separate background process
  // because it does not share the same memory space as the main app UI.
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("📩 Background message received: ${message.messageId}");
  }
}

void main() async {
  // Required by the framework to perform asynchronous initializations before rendering UI
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Connects our Flutter app to the underlying native Firebase engine.
    await Firebase.initializeApp();

    // Registers our background function with the Firebase Cloud Messaging library
    // so the OS knows exactly who to notify when a new background push arrives.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await initDependencies();

    // Optional: Log successful startup flow only while building locally
    if (kDebugMode) {
      print('🚀 Core systems initialized successfully.');
    }
  } catch (error, stackTrace) {
    if (kDebugMode) {
      print('❌ Critical System Boot Failure: $error');
      print(stackTrace);
    }
    // Note: Once we set up a remote crash tracker later, exceptions will be piped here.
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentUserCubit>(
          create: (_) => serviceLocator<CurrentUserCubit>(),
        ),
        BlocProvider<ThemeBloc>(create: (_) => serviceLocator<ThemeBloc>()),
        BlocProvider<AuthBloc>(
          create: (_) => serviceLocator<AuthBloc>()..add(AuthCheckSession()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Instagram Clone',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: serviceLocator<AppRouter>().config,
          );
        },
      ),
    );
  }
}
