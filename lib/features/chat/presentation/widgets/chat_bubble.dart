import 'package:flutter/material.dart';

/// A presentation layout component that renders an individual message balloon inside the chat thread.
///
/// Dynamically aligns itself to the left or right and adjusts its colors, text styling,
/// and border radius depending on whether the message was sent by the current user or the peer.
class ChatBubble extends StatelessWidget {
  /// The raw textual message body to display.
  final String content;

  /// Flags whether the message was sent by the authenticated client user (`true`) or the chat partner (`false`).
  final bool isMe;

  /// Creates an immutable message frame configuration instance of [ChatBubble].
  const ChatBubble({super.key, required this.content, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      // Right alignment signifies outbox messages, left alignment signifies incoming messages
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            // Trim the bottom corners to emphasize visual asymmetry based on message ownership
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: isMe
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
