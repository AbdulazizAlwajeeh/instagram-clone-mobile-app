import 'package:fpdart/fpdart.dart';
import '../../../error/failures.dart';
import '../../../usecase/usecase.dart';
import '../repositories/post_detail_repository.dart';

/// Business rule orchestrating the submission of a user-generated content report.
///
/// Interacts directly with the [PostRepository] contract to dispatch the report payload.
class ReportPost implements UseCase<Unit, String> {
  final PostDetailRepository _repository;

  /// Creates a [ReportPostUseCase] instance with injected repository dependencies.
  const ReportPost(this._repository);

  @override
  Future<Either<Failure, Unit>> call(postId) async {
    return await _repository.reportPost(postId: postId);
  }
}
