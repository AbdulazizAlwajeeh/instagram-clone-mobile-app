import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/app_user/domain/entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// A dedicated application use case tasked with validating session footprints on launch.
///
/// Coordinates early startup operations by querying the lower [AuthRepository] tier
/// to recover or establish identity sessions without tracking parameter demands.
class GetCurrentUser implements UseCase<AppUser?, NoParams> {
  /// The structural domain repository boundary handling security context transitions.
  final AuthRepository repository;

  /// Creates a business layer operation worker bound to the active authentication [repository].
  const GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, AppUser?>> call(NoParams params) async {
    // Forwards the execution check directly to underlying credential storage interfaces.
    return await repository.getCurrentUser();
  }
}
