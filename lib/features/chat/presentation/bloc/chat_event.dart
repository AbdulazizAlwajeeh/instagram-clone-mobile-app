import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';

sealed class ChatEvent {
  const ChatEvent();
}

/// Dispatched to initialize real-time reactive streaming hooks for the active chat tiles list.
class ChatListSubscriptionRequested extends ChatEvent {
  const ChatListSubscriptionRequested();
}

/// Dispatched internally by the stream pipeline whenever the database table sends fresh chat tiles data.
class ChatListUpdated extends ChatEvent {
  final List<Chat> chats;

  const ChatListUpdated(this.chats);
}

/// Dispatched when entering an individual chat view to request message streams and reset the unread status.
class ChatCanvasSubscriptionRequested extends ChatEvent {
  final String chatId;

  const ChatCanvasSubscriptionRequested({required this.chatId});
}

/// Dispatched internally by the message stream pipeline whenever fresh chat logs enter the system.
class ChatCanvasUpdated extends ChatEvent {
  final List<Message> messages;

  const ChatCanvasUpdated(this.messages);
}

/// Dispatched to process a transactional outgoing message payload.
class ChatMessageSent extends ChatEvent {
  final String chatId;
  final String receiverId;
  final String content;

  const ChatMessageSent({
    required this.chatId,
    required this.receiverId,
    required this.content,
  });
}

/// Dispatched when navigating away from a chat screen to safely dispose of active message stream hooks.
class ChatCanvasClosed extends ChatEvent {
  const ChatCanvasClosed();
}

class ChatRoomInitializationRequested extends ChatEvent {
  final String targetUserId;

  const ChatRoomInitializationRequested(this.targetUserId);
}
