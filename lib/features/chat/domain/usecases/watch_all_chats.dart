import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

/// Business use case responsible for observing real-time updates of all conversation channels.
///
/// Connects directly to the [ChatRepository] layer to continuously stream collections
/// of active [Chat] records matching the authenticated user profile session.
class WatchAllChats implements UseCase<Stream<List<Chat>>, NoParams> {
  final ChatRepository _chatRepository;

  /// Creates a single immutable instance of [WatchAllChats].
  const WatchAllChats(this._chatRepository);

  @override
  Future<Either<Failure, Stream<List<Chat>>>> call(NoParams params) async {
    return await _chatRepository.watchAllChats();
  }
}
