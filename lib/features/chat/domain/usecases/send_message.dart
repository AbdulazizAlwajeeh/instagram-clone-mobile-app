import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<Unit, SendMessageParams> {
  final ChatRepository _chatRepository;

  const SendMessage(this._chatRepository);

  @override
  Future<Either<Failure, Unit>> call(SendMessageParams params) async {
    return await _chatRepository.sendMessage(
      chatId: params.chatId,
      receiverId: params.receiverId,
      content: params.content,
    );
  }
}

class SendMessageParams {
  final String chatId;
  final String receiverId;
  final String content;

  const SendMessageParams({
    required this.chatId,
    required this.receiverId,
    required this.content,
  });
}
