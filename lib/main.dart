import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Required by the framework to perform asynchronous initializations before rendering UI
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Load localized environment asset values
    await dotenv.load(fileName: ".env");

    // 2. Safely initialize global Supabase client instances
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      publishableKey: dotenv.get('SUPABASE_ANON_KEY'),
    );

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
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text(
            'App Skeleton Ready.',
            style: TextStyle(fontSize: 16, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}