import 'package:fpdart/fpdart.dart';
import '../../../error/failures.dart';
import '../../../usecase/usecase.dart';
import '../repositories/notification_repository.dart';

/// Use case to request, fetch, and register the physical device push token.
///
/// Implements the base [UseCase] contract, accepting a [NoParams] token execution
/// wrapper and returning a successful functional [Unit] token wrapper upon completion.
class RegisterDeviceToken implements UseCase<Unit, NoParams> {
  /// Core domain repository interface contract for notification data operations.
  final NotificationRepository _notificationRepository;

  /// Creates a [RegisterDeviceToken] action with required repository dependency injection.
  const RegisterDeviceToken(this._notificationRepository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _notificationRepository.registerDeviceToken();
  }
}
