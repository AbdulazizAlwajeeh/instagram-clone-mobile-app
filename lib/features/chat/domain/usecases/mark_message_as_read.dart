import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/chat_repository.dart';

class MarkMessagesAsRead implements UseCase<Unit, String> {
  final ChatRepository _chatRepository;

  const MarkMessagesAsRead(this._chatRepository);

  @override
  Future<Either<Failure, Unit>> call(String chatId) async {
    return await _chatRepository.markMessagesAsRead(chatId);
  }
}
