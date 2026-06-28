import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';

sealed class ChatState {
  const ChatState();
}

/// Initial state of the state machine upon structural instantiation.
class ChatInitial extends ChatState {}

/// Core visual blocker state while initialization streams are establishing.
class ChatLoading extends ChatState {}

/// Emitted when data operations complete successfully, delivering state payloads to UI views.
class ChatLoaded extends ChatState {
  final List<Chat> chats;
  final List<Message> activeMessages;
  final String? activeChatId;
  final bool isSendingMessage;
  final String? errorMessage;

  const ChatLoaded({
    required this.chats,
    this.activeMessages = const [],
    this.activeChatId,
    this.isSendingMessage = false,
    this.errorMessage,
  });

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
      errorMessage: errorMessage, // Set to null unless explicitly passed
    );
  }
}

/// Emitted when data routing pipelines throw underlying system failures.
class ChatFailure extends ChatState {
  final String message;

  const ChatFailure(this.message);
}
