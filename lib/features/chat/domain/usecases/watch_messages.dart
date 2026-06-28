import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class WatchMessages implements UseCase<Stream<List<Message>>, String> {
  final ChatRepository _chatRepository;

  const WatchMessages(this._chatRepository);

  @override
  Future<Either<Failure, Stream<List<Message>>>> call(
    String chatId,
  ) async {
    return await _chatRepository.watchMessages(chatId);
  }
}
