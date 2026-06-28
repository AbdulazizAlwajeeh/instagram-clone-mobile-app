import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  /// Retrieves a real-time reactive data stream of active conversation models.
  ///
  /// Listens to rows inside the persistent engine to continuously emit updated
  /// collections of [ChatModel] components representing active user channels.
  Stream<List<ChatModel>> watchAllChats();

  /// Establishes or returns a single conversation row with a targeted user.
  ///
  /// Evaluates existing alphanumeric channel pairs. If no prior conversation
  /// matching the specific profiles exists, it writes a new entry initialization payload.
  /// Throws a [ServerException] if network transactions fail or data formatting breaks.
  Future<ChatModel> getOrCreateChat(String targetUserId);

  /// Retrieves a real-time reactive data stream of message entries for a specific conversation.
  ///
  /// Captures all incoming and outgoing text models linked to the target [chatId] sorted
  /// sequentially in chronological timeline alignment.
  Stream<List<MessageModel>> watchMessages(String chatId);

  /// Commits a new textual message transaction payload to the database storage.
  ///
  /// Inserts a fresh message data model row matching the target payload attributes.
  /// Throws a [ServerException] if submission validation checks fail or connectivity drops.
  Future<void> sendMessage({
    required String chatId,
    required String receiverId,
    required String content,
  });

  /// Mutates message status attributes to mark incoming elements as viewed.
  ///
  /// Target matches rows under the given [chatId] where the active authenticated session
  /// acts exclusively as the recipient entity, setting unread counter columns back to neutral.
  /// Throws a [ServerException] if the write mutation operation fails.
  Future<void> markMessagesAsRead(String chatId);
}
