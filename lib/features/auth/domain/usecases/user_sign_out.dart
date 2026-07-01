import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// A dedicated application use case tasked with tearing down the active user session.
///
/// Coordinates the teardown of security states by signaling the underlying domain [repository]
/// to clear structural access keys without requiring any runtime configuration variables.
class UserSignOut implements UseCase<void, NoParams> {
  /// The structural domain repository boundary handling session status transitions.
  final AuthRepository repository;

  /// Creates a session teardown business operation worker bound to the active [repository].
  const UserSignOut(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    // Forwards the execution check directly to drop system authorization maps.
    return await repository.signOut();
  }
}
