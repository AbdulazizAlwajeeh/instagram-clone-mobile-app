import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/app_user/domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Concrete operational repository orchestrating authentication workflows for the application.
///
/// Acts as the domain gateway that intercepts data layer exceptions thrown by [AuthRemoteDataSource]
/// and maps them into stable functional [Either] structures using generic [Failure] states.
class AuthRepositoryImpl implements AuthRepository {
  /// The abstract infrastructure interface handling direct network authentication lookups.
  final AuthRemoteDataSource remoteDataSource;

  /// Creates a unified authentication adapter bound to the active [remoteDataSource].
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Dispatches raw credentials payload execution downwards into infrastructure networks.
      final userModel = await remoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        username: username,
      );
      return right(
        userModel,
      ); // Packages success frames into functional right-hand channels.
    } on ServerException catch (e) {
      // Intercepts explicit backend-driven failure criteria flags cleanly.
      return left(AuthFailure(e.message));
    } catch (e) {
      // Catches unpredictable runtime processing blocks to isolate domain rules.
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Invokes remote network session matching validations against infrastructure endpoints.
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
      // Requests immediate access token validation drops across connected service pools.
      await remoteDataSource.signOut();
      return right(null); // Resolves a clear void execution path cleanly.
    } on ServerException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    try {
      // Queries the internal data layer manager to look up active operational sessions.
      final userModel = await remoteDataSource.getCurrentUser();
      return right(
        userModel,
      ); // Delivers a nullable AppUser representation smoothly to stream loops.
    } on ServerException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
