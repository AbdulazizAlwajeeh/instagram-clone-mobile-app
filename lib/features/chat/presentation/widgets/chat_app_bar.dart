import 'package:flutter/material.dart';

/// A presentation header widget tailored for individual conversation channels.
///
/// Implements [PreferredSizeWidget] to fit custom layout properties inside structural
/// [Scaffold.appBar] positions, rendering user avatars and display names adaptively.
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The distinct display handle text defining the message partner.
  final String username;

  /// The optional remote image location reference token pointing to user media files.
  final String? avatarUrl;

  /// Compiles immutable constraints around profile details and design parameters.
  const ChatAppBar({super.key, required this.username, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, size: 18)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              username,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Required by PreferredSizeWidget to let Scaffold size it correctly
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
