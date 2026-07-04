import 'package:flutter/material.dart';

/// A presentation interface component providing interactive message text composition utilities.
///
/// Wraps a single reactive input field row layout equipped with responsive hardware keyboard
/// submit detection triggers and an immediate hardware/software platform dispatch anchor action button.
class ChatInputField extends StatelessWidget {
  /// The logic manager staging and capturing real-time textual inputs.
  final TextEditingController controller;

  /// The action callback pipeline executing after submission interactions occur.
  final VoidCallback onSendPressed;

  /// Compiles immutable constraints around text controllers and submission triggers.
  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Message...",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  // Note: .surfaceContainerHigh is available in Flutter 3.13+
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                textInputAction: TextInputAction.send,
                // Triggers structural callback updates directly when keyboard enter triggers fire
                onSubmitted: (_) => onSendPressed(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              color: Theme.of(context).colorScheme.primary,
              onPressed: onSendPressed,
            ),
          ],
        ),
      ),
    );
  }
}
