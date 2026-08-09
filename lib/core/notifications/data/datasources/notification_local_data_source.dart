/// Abstract contract defining local device hardware notification interactions.
///
/// Encapsulates all direct communication hooks with the native mobile operating system
/// platform channels, managing push permission checks and local token generation.
abstract class NotificationLocalDataSource {
  /// Requests system push permissions and retrieves the unique device token string.
  ///
  /// Interacts with the native OS to show authorization pop-ups if needed.
  /// Returns a [String] containing the unique hardware device push token.
  /// Throws a [CacheException] or native plugin platform exception if retrieval fails.
  Future<String> getDeviceToken();

  /// Detects and returns the literal string name of the active operating platform.
  ///
  /// Returns either 'android' or 'ios' depending on the underlying hardware environment.
  String getPlatformType();
}
