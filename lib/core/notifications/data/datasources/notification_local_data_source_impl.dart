import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../error/exceptions.dart';
import 'notification_local_data_source.dart';

/// Concrete implementation of the local device notification data source.
///
/// Utilizes the [FirebaseMessaging] SDK plugin client wrapper to securely interface
/// with native Android and iOS operating system communication channels.
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  /// The underlying third-party plugin driver instance used for push operations.
  final FirebaseMessaging _firebaseMessaging;

  /// Creates an instance of [NotificationLocalDataSourceImpl] with an injected SDK client.
  const NotificationLocalDataSourceImpl(this._firebaseMessaging);

  @override
  Future<String> getDeviceToken() async {
    try {
      // Requests authorization permissions from the user (Required for iOS)
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Fetches the raw messaging registration token string from the hardware
      final token = await _firebaseMessaging.getToken();

      if (token != null) {
        return token;
      }

      throw const CacheException(
        'Notification permission denied or token null.',
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  String getPlatformType() {
    if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isAndroid) {
      return 'android';
    }
    return 'web';
  }
}
