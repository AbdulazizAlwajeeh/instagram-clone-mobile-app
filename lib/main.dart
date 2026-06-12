import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/core/router/app_router.dart';
import 'package:yemengram/core/theme/app_theme.dart';
import 'package:yemengram/core/theme/presentation/bloc/theme_state.dart';
import 'package:yemengram/init_dependencies.dart';

import 'core/theme/presentation/bloc/theme_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

void main() async {
  // Required by the framework to perform asynchronous initializations before rendering UI
  WidgetsFlutterBinding.ensureInitialized();

  try {
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
