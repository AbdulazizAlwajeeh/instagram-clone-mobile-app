import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class UserSignUp implements UseCase<AppUser, SignUpParams> {
  final AuthRepository repository;

  const UserSignUp(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(SignUpParams params) async {
    return await repository.signUpWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({
    required this.email,
    required this.password,
  });
}