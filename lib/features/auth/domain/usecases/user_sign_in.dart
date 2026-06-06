import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class UserSignIn implements UseCase<AppUser, SignInParams> {
  final AuthRepository repository;

  const UserSignIn(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(SignInParams params) async {
    return await repository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });
}