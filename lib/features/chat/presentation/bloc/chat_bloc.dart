import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/features/chat/domain/usecases/get_or_create_chat.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/watch_all_chats.dart';
import '../../domain/usecases/watch_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/mark_message_as_read.dart';
import 'chat_event.dart';
import 'chat_state.dart';

/// Presentation layer state machine coordinator managing Chat domain events and reactive data streams.
///
/// Subscribes to real-time database streams and dispatches atomic user actions, translating
/// business use-case outcomes into immutable UI presentation layer state vectors.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WatchAllChats _watchAllChats;
  final WatchMessages _watchMessages;
  final SendMessage _sendMessage;
  final MarkMessagesAsRead _markMessagesAsRead;
  final GetOrCreateChat _getOrCreateChat;

  // Stream pipeline controller containers to intercept connection leak drops
  StreamSubscription<List<Chat>>? _chatListSubscription;
  StreamSubscription<List<Message>>? _messageCanvasSubscription;

  /// Creates a concrete, fully bounded instance of [ChatBloc].
  ChatBloc({
    required WatchAllChats watchAllChats,
    required WatchMessages watchMessages,
    required SendMessage sendMessage,
    required MarkMessagesAsRead markMessagesAsRead,
    required GetOrCreateChat getOrCreateChat,
  }) : _watchAllChats = watchAllChats,
       _watchMessages = watchMessages,
       _sendMessage = sendMessage,
       _markMessagesAsRead = markMessagesAsRead,
       _getOrCreateChat = getOrCreateChat,
       super(ChatInitial()) {
    on<ChatListSubscriptionRequested>(_onListSubscriptionRequested);
    on<ChatListUpdated>(_onListUpdated);
    on<ChatCanvasSubscriptionRequested>(_onCanvasSubscriptionRequested);
    on<ChatCanvasUpdated>(_onCanvasUpdated);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatCanvasClosed>(_onCanvasClosed);
    on<ChatRoomInitializationRequested>(_onRoomInitializationRequested);
  }

  Future<void> _onListSubscriptionRequested(
    ChatListSubscriptionRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    // Cancel any pre-existing chat list subscription channels
    await _chatListSubscription?.cancel();

    final result = await _watchAllChats(NoParams());

    result.fold((failure) => emit(ChatFailure(failure.message)), (stream) {
      _chatListSubscription = stream.listen(
        (chats) => add(ChatListUpdated(chats)),
      );
    });
  }

  void _onListUpdated(ChatListUpdated event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      emit((state as ChatLoaded).copyWith(chats: event.chats));
    } else {
      emit(ChatLoaded(chats: event.chats));
    }
  }

  Future<void> _onCanvasSubscriptionRequested(
    ChatCanvasSubscriptionRequested event,
    Emitter<ChatState> emit,
  ) async {
    // 1. Instantly reset localized user unread message count badges
    await _markMessagesAsRead(event.chatId);

    // 2. Safely close down any streaming channels tied to previous canvas pages
    await _messageCanvasSubscription?.cancel();

    if (state is ChatLoaded) {
      emit(
        (state as ChatLoaded).copyWith(
          activeChatId: event.chatId,
          activeMessages: const [], // Flush previous historical canvas logs
        ),
      );
    } else {
      // Fallback state if entering directly from a deep link/tile without an active memory list
      emit(
        ChatLoaded(
          chats: const [],
          activeChatId: event.chatId,
          activeMessages: const [],
        ),
      );
    }

    final result = await _watchMessages(event.chatId);

    await result.fold(
      (failure) async {
        if (state is ChatLoaded) {
          emit((state as ChatLoaded).copyWith(errorMessage: failure.message));
        } else {
          emit(ChatFailure(failure.message));
        }
      },
      (stream) async {
        await _messageCanvasSubscription?.cancel();

        _messageCanvasSubscription = stream.listen(
          (messages) => add(ChatCanvasUpdated(messages)),
        );
      },
    );
  }

  void _onCanvasUpdated(ChatCanvasUpdated event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      emit((state as ChatLoaded).copyWith(activeMessages: event.messages));
    }
  }

  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) return;
    final currentState = state as ChatLoaded;

    emit(currentState.copyWith(isSendingMessage: true));

    final result = await _sendMessage(
      SendMessageParams(
        chatId: event.chatId,
        receiverId: event.receiverId,
        content: event.content,
      ),
    );

    result.fold(
      (failure) => emit(
        currentState.copyWith(
          isSendingMessage: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(currentState.copyWith(isSendingMessage: false)),
    );
  }

  Future<void> _onCanvasClosed(
    ChatCanvasClosed event,
    Emitter<ChatState> emit,
  ) async {
    // Free-tier connection optimizer: Dispose message stream hooks immediately upon backing out
    await _messageCanvasSubscription?.cancel();
    _messageCanvasSubscription = null;

    if (state is ChatLoaded) {
      emit(
        (state as ChatLoaded).copyWith(
          activeChatId: null,
          activeMessages: const [],
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    // Master clean breakdown routines to prevent framework connection leak drops
    await _chatListSubscription?.cancel();
    await _messageCanvasSubscription?.cancel();
    return super.close();
  }

  Future<void> _onRoomInitializationRequested(
    ChatRoomInitializationRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    // Call usecase to talk to Supabase and execute the sort/insert logic
    final result = await _getOrCreateChat(event.targetUserId);

    result.fold((failure) => emit(ChatFailure(failure.message)), (chat) {
      // Set the active room id so the bridge UI listener intercepts it and redirects
      emit(ChatLoaded(chats: [chat], activeChatId: chat.id));
    });
  }
}
