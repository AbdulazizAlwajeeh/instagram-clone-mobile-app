import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/app_user/domain/entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<AppUser?, NoParams> {
  final AuthRepository repository;

  const GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, AppUser?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}