import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

/// Business use case responsible for initializing or fetching a chat lane with a target user.
///
/// Instructs the [ChatRepository] infrastructure layer to look up an existing record
/// matching the profile pairing or instantly create a brand new channel row if none exists.
class GetOrCreateChat implements UseCase<Chat, String> {
  final ChatRepository _chatRepository;

  /// Creates a single immutable instance of [GetOrCreateChat].
  const GetOrCreateChat(this._chatRepository);

  @override
  Future<Either<Failure, Chat>> call(String targetUserId) async {
    return await _chatRepository.getOrCreateChat(targetUserId);
  }
}
