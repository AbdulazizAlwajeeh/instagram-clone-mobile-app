import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

/// Standard interface for all application business rules.
/// [SuccessType] represents the data returned on a successful operation.
/// [Params] represents the raw data required to execute the operation.
abstract class UseCase<SuccessType, Params> {
  /// Executes the core domain logic asynchronously.
  ///
  /// Returns a functional [Either] split containing a domain [Failure] on the left side
  /// or the target functional [SuccessType] payload on the right side.
  Future<Either<Failure, SuccessType>> call(Params params);
}

/// Used when a UseCase does not require any input parameters.
///
///  Acts as a structural type placeholder to eliminate arbitrary `null`
///  assignments in parameter definitions.
class NoParams {
  /// Instantiates a stateless, unmodifiable parameters block.
  const NoParams();
}
