/// Abstract contract defining remote database interactions for managing device notification tokens.
///
/// Serves as the direct interface boundary for persisting hardware registration data
/// to the remote cloud infrastructure, abstracting away network transport layers.
abstract class NotificationRemoteDataSource {
  /// Upserts a unique hardware registration token associated with the authenticated user session.
  ///
  /// Maps the active user ID to the physical device identifier string.
  /// Throws a [ServerException] if network transport fails or authorization is missing.
  Future<void> upsertDeviceToken({
    required String token,
    required String platform,
  });

  /// Deletes a specific hardware device token from the database cluster.
  ///
  /// Invoked strictly during user sign-out sequences to isolate data privacy boundaries.
  /// Throws a [ServerException] if database communication drops.
  Future<void> deleteDeviceToken({required String token});
}
