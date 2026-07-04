import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/chat_repository.dart';

/// Business use case responsible for dispatching new text messages inside a conversation.
///
/// Communicates payload parameters directly down to the [ChatRepository] infrastructure boundary
/// to persist and sync conversation entries across backend tables.
class SendMessage implements UseCase<Unit, SendMessageParams> {
  final ChatRepository _chatRepository;

  /// Creates an immutable instance of [SendMessage].
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

/// Parameter container encapsulating required fields for dispatching messages.
class SendMessageParams {
  /// The parent conversation channel unique identity key.
  final String chatId;

  /// The unique identification key belonging to the message recipient.
  final String receiverId;

  /// The raw text string context forming the message body.
  final String content;

  /// Creates a concrete parameter validation block instance.
  const SendMessageParams({
    required this.chatId,
    required this.receiverId,
    required this.content,
  });
}
