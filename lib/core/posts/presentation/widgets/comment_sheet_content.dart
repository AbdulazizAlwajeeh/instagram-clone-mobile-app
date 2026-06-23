import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/theme_extensions.dart';
import '../../domain/entities/comment.dart';

class CommentSheetContent extends StatefulWidget {
  final List<Comment> comments;
  final bool isLoading;
  final String? errorMessage;
  final Function(String) onCommentSubmitted;

  const CommentSheetContent({
    super.key,
    required this.comments,
    required this.isLoading,
    this.errorMessage,
    required this.onCommentSubmitted,
  });

  @override
  State<CommentSheetContent> createState() => _CommentSheetContentState();
}

class _CommentSheetContentState extends State<CommentSheetContent> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.md),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.xs),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Comments',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: widget.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : widget.errorMessage != null
                      ? Center(
                          child: Text(
                            widget.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : widget.comments.isEmpty
                      ? const Center(child: Text('No comments yet.'))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: widget.comments.length,
                          itemBuilder: (context, index) {
                            final comment = widget.comments[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    context.colorScheme.primaryContainer,
                                backgroundImage: comment.avatarUrl.isNotEmpty
                                    ? NetworkImage(comment.avatarUrl)
                                    : null,
                                child: comment.avatarUrl.isEmpty
                                    ? const Icon(Icons.person, size: 18)
                                    : null,
                              ),
                              title: Text(
                                comment.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(comment.text),
                            );
                          },
                        ),
                ),
                const Divider(height: 1),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: const InputDecoration(
                              hintText: 'Add a comment...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_textController.text.trim().isNotEmpty) {
                              widget.onCommentSubmitted(
                                _textController.text.trim(),
                              );
                              _textController.clear();
                              FocusScope.of(context).unfocus();
                            }
                          },
                          child: const Text('Post'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
