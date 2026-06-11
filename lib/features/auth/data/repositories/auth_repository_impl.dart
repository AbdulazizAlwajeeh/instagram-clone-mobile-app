import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userModel = await remoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        username: username,
      );
      return right(userModel);
    } on ServerException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      return right(userModel);
    } on ServerException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return right(userModel);
    } on ServerException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
