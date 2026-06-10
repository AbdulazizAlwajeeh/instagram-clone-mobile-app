import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/features/auth/presentation/pages/sign_in_page.dart';
import 'package:yemengram/init_dependencies.dart';

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
        BlocProvider<AuthBloc>(
          create: (_) => serviceLocator<AuthBloc>()..add(AuthCheckSession()),
        ),
      ],
      child: const MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        home: SignInPage(),
      ),
    );
  }
}