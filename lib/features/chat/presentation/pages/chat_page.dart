import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_user/domain/entities/app_user.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_tile.dart';

class ChatPage extends StatefulWidget {
  final void Function(String chatId, AppUser otherUser) onChatSelected;

  const ChatPage({super.key, required this.onChatSelected});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    // Start listening to the real-time chat table changes immediately on screen entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(const ChatListSubscriptionRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () {
              // Placeholder for user search / starting a new chat
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (state is ChatLoaded) {
            final chats = state.chats;

            if (chats.isEmpty) {
              return const Center(
                child: Text(
                  'No conversations yet.\nStart messaging friends!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, thickness: 0.5),
              itemBuilder: (context, index) {
                final chat = chats[index];

                // Formats the last message time nicely (e.g. "5m ago")
                final String timeDisplay = _formatTimestamp(
                  chat.lastMessageTime,
                );

                return ChatTile(
                  username: chat.otherUser.username,
                  avatarUrl: chat.otherUser.avatarUrl,
                  // Appends a "You: " prefix if you sent the last message
                  lastMessage: chat.lastMessage != null
                      ? (chat.isLastMessageFromMe
                            ? 'You: ${chat.lastMessage}'
                            : chat.lastMessage!)
                      : 'Started a conversation',
                  timeStamp: timeDisplay,
                  // If you sent the message, hide the unread dot count badge
                  unreadCount: chat.isLastMessageFromMe ? 0 : chat.unreadCount,
                  onTap: () {
                    widget.onChatSelected(chat.id, chat.otherUser);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Formats the DateTime into human-readable shorthand strings
  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
