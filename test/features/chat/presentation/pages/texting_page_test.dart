import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/chat/domain/entities/message.dart';
import 'package:yemengram/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:yemengram/features/chat/presentation/bloc/chat_event.dart';
import 'package:yemengram/features/chat/presentation/bloc/chat_state.dart';
import 'package:yemengram/features/chat/presentation/pages/texting_page.dart';
import 'package:yemengram/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:yemengram/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:yemengram/features/chat/presentation/widgets/chat_input_field.dart';

class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

void main() {
  late MockChatBloc mockChatBloc;

  setUpAll(() {
    registerFallbackValue(const ChatCanvasSubscriptionRequested(chatId: ''));
    registerFallbackValue(const ChatRoomInitializationRequested(''));
    registerFallbackValue(
      const ChatMessageSent(chatId: '', receiverId: '', content: ''),
    );
    registerFallbackValue(const ChatCanvasClosed());
  });

  setUp(() {
    mockChatBloc = MockChatBloc();
  });

  Widget createWidgetUnderTest({
    required String chatId,
    required AppUser targetUser,
  }) {
    return MaterialApp(
      home: BlocProvider<ChatBloc>.value(
        value: mockChatBloc,
        child: TextingPage(chatId: chatId, targetUser: targetUser),
      ),
    );
  }

  const tTargetUser = AppUser(
    id: 'partner_user_id_123',
    email: 'partner@yemengram.com',
    username: 'YemenUser',
    avatarUrl: null,
  );

  final tMessageFromMe = Message(
    id: 'msg_001',
    chatId: 'chat_active',
    senderId: 'current_user_id',
    receiverId: 'partner_user_id_123',
    content: 'Hello from Clean Architecture',
    isRead: true,
    createdAt: DateTime.now(),
  );

  final tMessageFromPartner = Message(
    id: 'msg_002',
    chatId: 'chat_active',
    senderId: 'partner_user_id_123',
    receiverId: 'current_user_id',
    content: 'Reply message testing text content',
    isRead: true,
    createdAt: DateTime.now(),
  );

  testWidgets(
    'Option A: should request message stream subscription on init when chatId is valid',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(ChatInitial());

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(chatId: 'chat_active', targetUser: tTargetUser),
      );
      await tester.pump();

      // Assert
      verify(
        () =>
            mockChatBloc.add(any(that: isA<ChatCanvasSubscriptionRequested>())),
      ).called(1);
      expect(find.byType(ChatAppBar), findsOneWidget);
      expect(find.byType(ChatInputField), findsOneWidget);
    },
  );

  testWidgets(
    'Option B: should dispatch ChatRoomInitializationRequested on init when chatId is "new"',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(ChatInitial());

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(chatId: 'new', targetUser: tTargetUser),
      );
      await tester.pump();

      // Assert
      verify(
        () =>
            mockChatBloc.add(any(that: isA<ChatRoomInitializationRequested>())),
      ).called(1);
    },
  );

  testWidgets(
    'should render placeholder empty message text if ChatLoaded contains no message items',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(
        const ChatLoaded(
          chats: [],
          activeChatId: 'chat_active',
          activeMessages: [],
        ),
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(chatId: 'chat_active', targetUser: tTargetUser),
      );

      // Assert
      expect(
        find.text('No messages here yet.\nSay hello to YemenUser!'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should render incoming and outgoing ChatBubble structures with correct parameter context alignment',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(
        ChatLoaded(
          chats: [],
          activeChatId: 'chat_active',
          activeMessages: [tMessageFromMe, tMessageFromPartner],
        ),
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(chatId: 'chat_active', targetUser: tTargetUser),
      );

      // Assert
      expect(find.byType(ChatBubble), findsNWidgets(2));
      expect(find.text('Hello from Clean Architecture'), findsOneWidget);
      expect(find.text('Reply message testing text content'), findsOneWidget);
    },
  );

  testWidgets(
    'should dispatch ChatMessageSent action bundle parameters when user triggers send callbacks',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(
        const ChatLoaded(
          chats: [],
          activeChatId: 'chat_active',
          activeMessages: [],
        ),
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(chatId: 'chat_active', targetUser: tTargetUser),
      );

      // Find text field widget inside ChatInputField and enter characters
      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      await tester.enterText(textFieldFinder, 'Testing message input fields');

      // Click the submission button layout anchor
      final sendButtonFinder = find.byIcon(Icons.send);
      if (sendButtonFinder.evaluate().isEmpty) {
        // Fallback if your ChatInputField uses an alternative button indicator design pattern
        await tester.tap(find.byType(IconButton).last);
      } else {
        await tester.tap(sendButtonFinder);
      }
      await tester.pump();

      // Assert
      verify(
        () => mockChatBloc.add(any(that: isA<ChatMessageSent>())),
      ).called(1);
    },
  );
}
