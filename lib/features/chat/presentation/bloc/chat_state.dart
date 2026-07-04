import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';

/// Base sealed state definition class for the Chat feature state machine.
sealed class ChatState {
  /// Creates a base initialization instance of [ChatState].
  const ChatState();
}

/// Initial state of the state machine upon structural instantiation.
class ChatInitial extends ChatState {}

/// Core visual blocker state while initialization streams are establishing.
class ChatLoading extends ChatState {}

/// Emitted when data operations complete successfully, delivering state payloads to UI views.
class ChatLoaded extends ChatState {
  /// The collection of all active conversation channel elements.
  final List<Chat> chats;

  /// The chronological list of message elements associated with the currently open conversation.
  final List<Message> activeMessages;

  /// The unique identification key of the chat conversation currently actively viewed by the user.
  final String? activeChatId;

  /// A layout flag denoting if an outgoing text message transaction payload is actively uploading.
  final bool isSendingMessage;

  /// A transient field containing message text strings if an operation fails without destroying existing state caches.
  final String? errorMessage;

  /// Creates a populated data context instance of [ChatLoaded].
  const ChatLoaded({
    required this.chats,
    this.activeMessages = const [],
    this.activeChatId,
    this.isSendingMessage = false,
    this.errorMessage,
  });

  /// Generates a duplicated [ChatLoaded] instance with updated parameters.
  ///
  /// Clears out the [errorMessage] by default unless a new textual failure value is explicitly passed.
  ChatLoaded copyWith({
    List<Chat>? chats,
    List<Message>? activeMessages,
    String? activeChatId,
    bool? isSendingMessage,
    String? errorMessage,
  }) {
    return ChatLoaded(
      chats: chats ?? this.chats,
      activeMessages: activeMessages ?? this.activeMessages,
      activeChatId: activeChatId ?? this.activeChatId,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      errorMessage: errorMessage,
    );
  }
}

/// Emitted when data routing pipelines throw underlying system failures.
class ChatFailure extends ChatState {
  /// The descriptive human-readable failure communication context message.
  final String message;

  /// Creates a failure state termination block.
  const ChatFailure(this.message);
}
