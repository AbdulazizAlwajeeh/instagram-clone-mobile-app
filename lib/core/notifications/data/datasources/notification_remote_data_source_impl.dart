import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../error/exceptions.dart';
import 'notification_remote_data_source.dart';

/// Concrete implementation of [NotificationRemoteDataSource] powered by the Supabase Client SDK.
///
/// Communicates directly with the remote Postgres cluster using asynchronous HTTP
/// connection pooling handled by Postgrest.
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  /// The centralized, third-party backend database connection manager client instance.
  final SupabaseClient _supabaseClient;

  /// Creates a [NotificationRemoteDataSourceImpl] instance with explicit client injection.
  const NotificationRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<void> upsertDeviceToken({
    required String token,
    required String platform,
  }) async {
    try {
      // Safely check if a cryptographically signed user session token is present
      final currentUser = _supabaseClient.auth.currentUser;
      if (currentUser == null) {
        throw const ServerException(
          'Database operation blocked: No active authenticated user session discovered.',
        );
      }

      // Upserts target record. Relying on Postgres unique constraints to handle updates.
      await _supabaseClient.from('user_device_tokens').upsert({
        'user_id': currentUser.id,
        'device_token': token,
        'platform': platform,
      });
    } on PostgrestException catch (e) {
      // Intercept and wrap native database engine driver runtime errors safely
      throw ServerException('Database write operation failed: ${e.message}');
    } catch (e) {
      // Intercept broad platform runtime threading or parsing failures
      throw ServerException(
        'An unexpected remote network exception occurred: $e',
      );
    }
  }

  @override
  Future<void> deleteDeviceToken({required String token}) async {
    try {
      // Executes a scoped query match targeting the physical device token string matching signature
      await _supabaseClient.from('user_device_tokens').delete().match({
        'device_token': token,
      });
    } on PostgrestException catch (e) {
      throw ServerException('Database delete operation failed: ${e.message}');
    } catch (e) {
      throw ServerException(
        'An unexpected remote network exception occurred: $e',
      );
    }
  }
}
