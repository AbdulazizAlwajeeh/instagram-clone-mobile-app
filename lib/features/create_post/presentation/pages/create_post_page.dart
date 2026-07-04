import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yemengram/core/router/app_router.dart';
import 'package:yemengram/features/create_post/presentation/widgets/caption_input_field.dart';
import 'package:yemengram/features/create_post/presentation/widgets/image_source_picker.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../bloc/create_post_bloc.dart';
import '../widgets/media_picker.dart';

/// Presentation view layer enabling users to compose captions and pick media attachments.
///
/// Orchestrates form lifecycles, native asset selection via device camera/gallery,
/// and maps UI interaction hooks directly to the underlying state machine.
class CreatePostPage extends StatefulWidget {
  /// Instantiates a new post creation form view window.
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  /// Dispatches a platform request to load binary pictures from a native [ImageSource].
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Optimizes file size for uploads
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path); // Updates UI with new image
        });
      }
    } catch (e) {
      // Handle permission denied or picking errors here gracefully
      debugPrint('Error picking image: $e');
    }
  }

  /// Triggers submission validation constraints before requesting an export event.
  void _onPublishPressed(CreatePostState state) {
    if (state is CreatePostLoading) return;

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    final trimmedCaption = _captionController.text.trim();

    context.read<CreatePostBloc>().add(
      PublishPostEvent(
        caption: trimmedCaption.isEmpty ? '' : trimmedCaption,
        mediaFile: _selectedImage!,
      ),
    );
  }

  /// Resets internal parameters and routes the user back to the primary feed section.
  void _resetAndPop() {
    setState(() {
      _captionController.clear();
      _selectedImage = null;
      context.go(AppRouter.feedPath);
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
        if (state is CreatePostSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post published successfully! 🎉')),
          );
          _resetAndPop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'New Post',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _resetAndPop();
              },
            ),
            actions: [
              state is CreatePostLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        _onPublishPressed(state);
                      },
                      child: Text(
                        'Publish',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaPickerPlaceholder(
                  selectedImage: _selectedImage,
                  onTap: (context) =>
                      ImageSourcePicker.show(context, _pickImage),
                ),
                const Divider(height: 1.0),
                CaptionInputField(controller: _captionController),
                const Divider(height: 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
