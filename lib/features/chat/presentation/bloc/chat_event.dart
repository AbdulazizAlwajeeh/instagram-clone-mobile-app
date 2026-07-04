import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';

/// Base architectural sealed event class for the Chat feature state machine.
///
/// Intercepted exclusively by the [ChatBloc] component to map incoming
/// user intentions and internal stream updates down to UI state mutations.
sealed class ChatEvent {
  /// Creates a baseline context instance of [ChatEvent].
  const ChatEvent();
}

/// Dispatched to initialize real-time reactive streaming hooks for the active chat tiles list.
///
/// Triggers the background pipeline responsible for listening to global room changes.
class ChatListSubscriptionRequested extends ChatEvent {
  /// Creates a subscription invocation block.
  const ChatListSubscriptionRequested();
}

/// Dispatched internally by the stream pipeline whenever the database table sends fresh chat tiles data.
///
/// Updates the cached list layout structure without destroying active screen focus nodes.
class ChatListUpdated extends ChatEvent {
  /// The newly updated collection of chat items delivered from the database stream.
  final List<Chat> chats;

  /// Creates a chat list sync event wrapper.
  const ChatListUpdated(this.chats);
}

/// Dispatched when entering an individual chat view to request message streams and reset the unread status.
class ChatCanvasSubscriptionRequested extends ChatEvent {
  /// The unique identity reference token matching the target conversation room database row.
  final String chatId;

  /// Creates an active channel initialization invocation signature block.
  const ChatCanvasSubscriptionRequested({required this.chatId});
}

/// Dispatched internally by the message stream pipeline whenever fresh chat logs enter the system.
class ChatCanvasUpdated extends ChatEvent {
  /// The chronological list of message elements synchronized down from the persistent layer.
  final List<Message> messages;

  /// Creates an message stream update sync event.
  const ChatCanvasUpdated(this.messages);
}

/// Dispatched to process a transactional outgoing message payload submission block.
class ChatMessageSent extends ChatEvent {
  /// The identity key identifying the target conversation lane matrix.
  final String chatId;

  /// The unique user identifier key belonging to the account receiving this submission block.
  final String receiverId;

  /// The raw context body characters forming the transmission string.
  final String content;

  /// Creates an outgoing transaction dispatch execution state.
  const ChatMessageSent({
    required this.chatId,
    required this.receiverId,
    required this.content,
  });
}

/// Dispatched when navigating away from a chat screen to safely dispose of active message stream hooks.
///
/// Resets tracking flags to prevent leaks or race conditions across message layouts.
class ChatCanvasClosed extends ChatEvent {
  /// Clears active canvas subscription tracking bindings.
  const ChatCanvasClosed();
}

/// Dispatched when starting a chat conversation using an external profile view card context parameter wrapper.
class ChatRoomInitializationRequested extends ChatEvent {
  /// The unique validation identification token key string of the targeted user.
  final String targetUserId;

  /// Establishes an explicit communication line preparation process mapping configuration.
  const ChatRoomInitializationRequested(this.targetUserId);
}
