import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

/// Standard interface for all application business rules.
/// [SuccessType] represents the data returned on a successful operation.
/// [Params] represents the raw data required to execute the operation.
abstract class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

/// Used when a UseCase does not require any input parameters.
class NoParams {
  const NoParams();
}