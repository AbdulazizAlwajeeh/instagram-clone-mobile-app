import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:yemengram/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:yemengram/features/chat/presentation/widgets/chat_input_field.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class TextingPage extends StatefulWidget {
  final String chatId;
  final AppUser targetUser;

  const TextingPage({
    super.key,
    required this.chatId,
    required this.targetUser,
  });

  @override
  State<TextingPage> createState() => _TextingPageState();
}

class _TextingPageState extends State<TextingPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Keep track of the active chatId locally if it starts as null
  String? _activeChatId;

  @override
  void initState() {
    super.initState();
    _activeChatId = widget.chatId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_activeChatId != 'new') {
        // Option A: Conversation already exists. Start streaming text messages live!
        context.read<ChatBloc>().add(
          ChatCanvasSubscriptionRequested(chatId: _activeChatId!),
        );
      } else {
        // Option B: Coming from profile page button. Let the BLoC create the room row silently.
        context.read<ChatBloc>().add(
          ChatRoomInitializationRequested(widget.targetUser.id),
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSendPressed() {
    final messageText = _textController.text.trim();
    // Safety exit to shield Supabase from executing empty message strings
    if (messageText.isEmpty || _activeChatId == 'new') return;

    // Dispatch the sendMessage operation parameter packet to our unified BLoC
    context.read<ChatBloc>().add(
      ChatMessageSent(
        chatId: _activeChatId!,
        receiverId: widget.targetUser.id,
        content: messageText,
      ),
    );

    _textController.clear();
    _animateToBottom();
  }

  void _animateToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Intercept backward navigation steps to release database socket streams
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<ChatBloc>().add(ChatCanvasClosed());
        }
      },
      child: Scaffold(
        appBar: ChatAppBar(
          username: widget.targetUser.username,
          avatarUrl: widget.targetUser.avatarUrl,
        ),
        body: Column(
          children: [
            // 1. Message Logs Canvas Grid Area
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  // If the background initialization finishes, catch the newly created chatId
                  if (state is ChatLoaded) {
                    if (_activeChatId == 'new' && state.activeChatId != null) {
                      setState(() {
                        _activeChatId = state.activeChatId;
                      });
                      // Instantly pivot to streaming messages for this brand new room
                      context.read<ChatBloc>().add(
                        ChatCanvasSubscriptionRequested(chatId: _activeChatId!),
                      );
                    }

                    // Automatically shift viewpoint boundaries if incoming messages arrive live
                    if (state.activeMessages.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _animateToBottom(),
                      );
                    }
                  }
                },
                builder: (context, state) {
                  // If the background initialization is still writing the row to Supabase, show a loader
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatFailure) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is ChatLoaded) {
                    // Check if we are still waiting for the listener's event to swap 'new' with the activeChatId
                    if (_activeChatId == 'new') {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = state.activeMessages;

                    if (messages.isEmpty) {
                      return Center(
                        child: Text(
                          'No messages here yet.\nSay hello to ${widget.targetUser.username}!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        final bool isMe =
                            message.senderId != widget.targetUser.id;

                        return ChatBubble(content: message.content, isMe: isMe);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            // 2. Chat Input Control Panel Strip
            ChatInputField(
              controller: _textController,
              onSendPressed: _onSendPressed,
            ),
          ],
        ),
      ),
    );
  }
}
