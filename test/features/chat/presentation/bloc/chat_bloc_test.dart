import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/usecase/usecase.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/chat/domain/entities/chat.dart';
import 'package:yemengram/features/chat/domain/entities/message.dart';
import 'package:yemengram/features/chat/domain/usecases/get_or_create_chat.dart';
import 'package:yemengram/features/chat/domain/usecases/watch_all_chats.dart';
import 'package:yemengram/features/chat/domain/usecases/watch_messages.dart';
import 'package:yemengram/features/chat/domain/usecases/send_message.dart';
import 'package:yemengram/features/chat/domain/usecases/mark_message_as_read.dart';
import 'package:yemengram/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:yemengram/features/chat/presentation/bloc/chat_event.dart';
import 'package:yemengram/features/chat/presentation/bloc/chat_state.dart';

// Mock dependencies setup configuration via Mocktail interfaces
class MockWatchAllChats extends Mock implements WatchAllChats {}

class MockWatchMessages extends Mock implements WatchMessages {}

class MockSendMessage extends Mock implements SendMessage {}

class MockMarkMessagesAsRead extends Mock implements MarkMessagesAsRead {}

class MockGetOrCreateChat extends Mock implements GetOrCreateChat {}

void main() {
  late ChatBloc chatBloc;
  late MockWatchAllChats mockWatchAllChats;
  late MockWatchMessages mockWatchMessages;
  late MockSendMessage mockSendMessage;
  late MockMarkMessagesAsRead mockMarkMessagesAsRead;
  late MockGetOrCreateChat mockGetOrCreateChat;

  setUpAll(() {
    // Register custom SendMessageParams fallback to handle native object matching in mock parameters
    registerFallbackValue(
      const SendMessageParams(chatId: '', receiverId: '', content: ''),
    );
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockWatchAllChats = MockWatchAllChats();
    mockWatchMessages = MockWatchMessages();
    mockSendMessage = MockSendMessage();
    mockMarkMessagesAsRead = MockMarkMessagesAsRead();
    mockGetOrCreateChat = MockGetOrCreateChat();

    chatBloc = ChatBloc(
      watchAllChats: mockWatchAllChats,
      watchMessages: mockWatchMessages,
      sendMessage: mockSendMessage,
      markMessagesAsRead: mockMarkMessagesAsRead,
      getOrCreateChat: mockGetOrCreateChat,
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  const tChatId = 'chat_123';
  const tTargetUserId = 'user_abc';
  const tErrorMessage = 'Connection Interrupted';

  final tChat = Chat(
    id: tChatId,
    lastMessageTime: DateTime.now(),
    isLastMessageFromMe: true,
    otherUser: const AppUser(
      id: tTargetUserId,
      email: 'a@b.com',
      username: 'A',
    ),
  );

  final tMessage = Message(
    id: 'm1',
    chatId: tChatId,
    senderId: 'me',
    receiverId: tTargetUserId,
    content: 'Hello',
    isRead: false,
    createdAt: DateTime.now(),
  );

  test('Initial state should be ChatInitial upon instantiation', () {
    expect(chatBloc.state, isA<ChatInitial>());
  });

  group('ChatListSubscriptionRequested Events Tracking Mapping', () {
    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoading] and hook background subscription loop maps upon successful setup execution',
      build: () {
        when(
          () => mockWatchAllChats(any()),
        ).thenAnswer((_) async => Right(Stream.value([tChat])));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const ChatListSubscriptionRequested()),
      expect: () => [
        isA<ChatLoading>(),
        isA<ChatLoaded>().having((s) => s.chats, 'chats', [tChat]),
      ],
      verify: (_) {
        verify(() => mockWatchAllChats(any())).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoading, ChatFailure] when usecase drops stream initialization hooks',
      build: () {
        when(
          () => mockWatchAllChats(any()),
        ).thenAnswer((_) async => const Left(ServerFailure(tErrorMessage)));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const ChatListSubscriptionRequested()),
      expect: () => [
        isA<ChatLoading>(),
        isA<ChatFailure>().having((s) => s.message, 'message', tErrorMessage),
      ],
    );
  });

  group('ChatCanvasSubscriptionRequested Events Tracking Mapping', () {
    blocTest<ChatBloc, ChatState>(
      'should trigger unread reset, flush background caches, and emit updated canvas streams successfully',
      build: () {
        when(
          () => mockMarkMessagesAsRead(any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockWatchMessages(any()),
        ).thenAnswer((_) async => Right(Stream.value([tMessage])));
        return chatBloc;
      },
      act: (bloc) =>
          bloc.add(const ChatCanvasSubscriptionRequested(chatId: tChatId)),
      expect: () => [
        isA<ChatLoaded>()
            .having((s) => s.activeChatId, 'activeChatId', tChatId)
            .having((s) => s.activeMessages, 'activeMessages', isEmpty),
        isA<ChatLoaded>().having((s) => s.activeMessages, 'activeMessages', [
          tMessage,
        ]),
      ],
      verify: (_) {
        verify(() => mockMarkMessagesAsRead(tChatId)).called(1);
        verify(() => mockWatchMessages(tChatId)).called(1);
      },
    );
  });

  group('ChatMessageSent Events Tracking Mapping', () {
    blocTest<ChatBloc, ChatState>(
      'should toggle isSendingMessage parameters flag configuration and process successful transmission payloads',
      seed: () => ChatLoaded(chats: [tChat]),
      build: () {
        when(
          () => mockSendMessage(any()),
        ).thenAnswer((_) async => const Right(unit));
        return chatBloc;
      },
      act: (bloc) => bloc.add(
        ChatMessageSent(
          chatId: tChatId,
          receiverId: tTargetUserId,
          content: 'Hi',
        ),
      ),
      expect: () => [
        isA<ChatLoaded>().having(
          (s) => s.isSendingMessage,
          'isSendingMessage',
          true,
        ),
        isA<ChatLoaded>().having(
          (s) => s.isSendingMessage,
          'isSendingMessage',
          false,
        ),
      ],
      verify: (_) {
        verify(() => mockSendMessage(any())).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should safely attach transient error message keys without breaking active chat canvas logs upon transmission drop',
      seed: () => ChatLoaded(chats: [tChat]),
      build: () {
        when(
          () => mockSendMessage(any()),
        ).thenAnswer((_) async => const Left(ServerFailure(tErrorMessage)));
        return chatBloc;
      },
      act: (bloc) => bloc.add(
        ChatMessageSent(
          chatId: tChatId,
          receiverId: tTargetUserId,
          content: 'Hi',
        ),
      ),
      expect: () => [
        isA<ChatLoaded>().having(
          (s) => s.isSendingMessage,
          'isSendingMessage',
          true,
        ),
        isA<ChatLoaded>()
            .having((s) => s.isSendingMessage, 'isSendingMessage', false)
            .having((s) => s.errorMessage, 'errorMessage', tErrorMessage),
      ],
    );
  });

  group('ChatCanvasClosed Events Handling', () {
    blocTest<ChatBloc, ChatState>(
      'should clear active focus context nodes parameters upon backing out from conversation screen canvas',
      seed: () => ChatLoaded(
        chats: [tChat],
        activeMessages: [tMessage],
      ),
      build: () => chatBloc,
      act: (bloc) => bloc.add(const ChatCanvasClosed()),
      expect: () => [
        isA<ChatLoaded>()
            .having((s) => s.activeChatId, 'activeChatId', isNull)
            .having((s) => s.activeMessages, 'activeMessages', isEmpty),
      ],
    );
  });

  group('ChatRoomInitializationRequested Events Tracking Mapping', () {
    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoading, ChatLoaded] with pre-filled items when allocating target room rows',
      build: () {
        when(
          () => mockGetOrCreateChat(any()),
        ).thenAnswer((_) async => Right(tChat));
        return chatBloc;
      },
      act: (bloc) => bloc.add(ChatRoomInitializationRequested(tTargetUserId)),
      expect: () => [
        isA<ChatLoading>(),
        isA<ChatLoaded>()
            .having((s) => s.activeChatId, 'activeChatId', tChatId)
            .having((s) => s.chats, 'chats', [tChat]),
      ],
    );
  });
}
