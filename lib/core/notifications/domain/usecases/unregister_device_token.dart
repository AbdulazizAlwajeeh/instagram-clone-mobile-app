import 'package:fpdart/fpdart.dart';
import '../../../usecase/usecase.dart';
import '../../../error/failures.dart';
import '../repositories/notification_repository.dart';

/// Use case to safely remove and unregister the current device token from the database.
///
/// Implements the base [UseCase] contract, accepting a [NoParams] token execution
/// wrapper and returning a successful functional [Unit] token wrapper upon completion.
class UnregisterDeviceToken implements UseCase<Unit, NoParams> {
  /// Core domain repository interface contract for notification data operations.
  final NotificationRepository _notificationRepository;

  /// Creates an [UnregisterDeviceToken] action with required repository dependency injection.
  const UnregisterDeviceToken(this._notificationRepository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _notificationRepository.unregisterDeviceToken();
  }
}
