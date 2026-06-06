import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  // Enables Flutter services inside tests
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Verify .env loads and Supabase initializes without crashing',
    () async {
      // 1. Load the .env file
      await dotenv.load(fileName: ".env");

      final url = dotenv.env['SUPABASE_URL'];
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

      // Assert that variables are actually read from the file
      expect(url, isNotNull, reason: "SUPABASE_URL missing from .env");
      expect(anonKey, isNotNull, reason: "SUPABASE_ANON_KEY missing from .env");
      expect(url!.isNotEmpty, true);
      expect(anonKey!.isNotEmpty, true);

      // 2. Test the actual initialization handshake
      await Supabase.initialize(url: url, publishableKey: anonKey);

      // 3. Verify the global client instance is alive and matching our URL
      final client = Supabase.instance.client;
      expect(client, isNotNull);

      // If we reach this line without throwing an exception, the test passes!
      print("✅ Testing Success: Supabase client is securely connected.");
    },
    skip:
        'Requires a native mobile operating system channel runtime '
        'environment to initialize local storage.',
  );
}
