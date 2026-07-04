import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

/// Business use case responsible for capturing real-time updates of message logs.
///
/// Coordinates directly with the [ChatRepository] domain contract layer to continuously
/// stream sequential message list payloads associated with a target chat channel.
class WatchMessages implements UseCase<Stream<List<Message>>, String> {
  final ChatRepository _chatRepository;

  /// Creates a single immutable instance of [WatchMessages].
  const WatchMessages(this._chatRepository);

  @override
  Future<Either<Failure, Stream<List<Message>>>> call(String chatId) async {
    return await _chatRepository.watchMessages(chatId);
  }
}
