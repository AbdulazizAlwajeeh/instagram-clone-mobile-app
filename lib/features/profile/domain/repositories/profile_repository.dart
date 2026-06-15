import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  /// Retrieves a targeted public user profile by their distinct identification key.
  ///
  /// Returns a [ServerFailure] on the left side if data fetching fails,
  /// or a [UserProfile] entity on the right side upon a successful query.
  Future<Either<Failure, UserProfile>> getUserProfile(String userId);
}
