import 'package:fpdart/fpdart.dart';
import '../../../error/failures.dart';

/// Abstract contract defining the core domain interactions for notifications.
///
/// Serves as the architectural boundary interface between the domain layer use cases
/// and the data layer implementation. Expresses notification management requirements
/// independently of any remote databases, hardware APIs, or push providers.
abstract class NotificationRepository {
  /// Requests the unique push token from the device hardware and registers it to the database.
  ///
  /// Automatically detects the physical operating system platform (Android/iOS),
  /// requests necessary permissions from the user, and securely upserts the token.
  /// Returns a [Failure] on the left side, or [Unit] on the right side upon
  /// success.
  Future<Either<Failure, Unit>> registerDeviceToken();

  /// Unregisters the current device push token from the remote database table.
  ///
  /// This must be invoked during the sign-out lifecycle to prevent private push notifications
  /// from being delivered to a hardware device after a user logs out.
  /// Returns a [Failure] on the left side, or [Unit] on the right side upon
  /// success.
  Future<Either<Failure, Unit>> unregisterDeviceToken();
}
