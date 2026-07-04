import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/chat/domain/entities/chat.dart';
import 'package:yemengram/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:yemengram/features/chat/presentation/bloc/chat_event.dart';
import 'package:yemengram/features/chat/presentation/bloc/chat_state.dart';
import 'package:yemengram/features/chat/presentation/pages/chat_page.dart';
import 'package:yemengram/features/chat/presentation/widgets/chat_tile.dart';

// Create the mock state machine block structure using mocktail + bloc_test layers
class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

void main() {
  late MockChatBloc mockChatBloc;
  late List<String> selectedChatIds;
  late List<AppUser> selectedUsers;

  setUpAll(() {
    registerFallbackValue(const ChatListSubscriptionRequested());
  });

  setUp(() {
    mockChatBloc = MockChatBloc();
    selectedChatIds = [];
    selectedUsers = [];
  });

  // Reusable testing layout wrapper helper injecting the mock bloc into the page widget context trees
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ChatBloc>.value(
        value: mockChatBloc,
        child: ChatPage(
          onChatSelected: (chatId, user) {
            selectedChatIds.add(chatId);
            selectedUsers.add(user);
          },
        ),
      ),
    );
  }

  const tAppUser = AppUser(
    id: 'user_partner_99',
    email: 'partner@yemengram.com',
    username: 'yemen_chat_buddy',
    avatarUrl: null,
  );

  final tChat = Chat(
    id: 'chat_channel_abc',
    lastMessage: 'Clean architecture widget test structure verification.',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
    isLastMessageFromMe: false,
    otherUser: tAppUser,
    unreadCount: 3,
  );

  testWidgets(
    'should dispatch ChatListSubscriptionRequested event upon screen initialization mounting lifecycle',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(ChatInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester
          .pump(); // Allow frame layout post callback dispatch loops to settle out

      // Assert
      verify(
        () => mockChatBloc.add(const ChatListSubscriptionRequested()),
      ).called(1);
    },
  );

  testWidgets(
    'should render CircularProgressIndicator loading animation elements when state is ChatLoading',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(ChatLoading());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should render descriptive failure message text layout configuration when state is ChatFailure',
    (WidgetTester tester) async {
      // Arrange
      const tErrorMessage =
          'Database stream transaction reference connection timeout.';
      when(
        () => mockChatBloc.state,
      ).thenReturn(const ChatFailure(tErrorMessage));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text(tErrorMessage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'should render empty list message layout placeholders when state is ChatLoaded but chats collections remain empty',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(const ChatLoaded(chats: []));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(
        find.text('No conversations yet.\nStart messaging friends!'),
        findsOneWidget,
      );
      expect(find.byType(ListView), findsNothing);
    },
  );

  testWidgets(
    'should render lazy-loaded ChatTile components with matching payload data strings when state is ChatLoaded',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(ChatLoaded(chats: [tChat]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ChatTile), findsOneWidget);
      expect(find.text('yemen_chat_buddy'), findsOneWidget);
      expect(
        find.text('Clean architecture widget test structure verification.'),
        findsOneWidget,
      );
      expect(find.text('5m ago'), findsOneWidget);
    },
  );

  testWidgets(
    'should execute user callback configurations parameters when a ChatTile row layout component receives press events',
    (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state).thenReturn(ChatLoaded(chats: [tChat]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byType(ChatTile));
      await tester.pump(); // Settle layout tap animation frame states

      // Assert
      expect(selectedChatIds, contains('chat_channel_abc'));
      expect(selectedUsers, contains(tAppUser));
    },
  );
}
