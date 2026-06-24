import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final String? currentImageUrl;
  final File? selectedImageFile;
  final Function(File pickedFile) onImageSelected;

  const ProfileAvatarPicker({
    super.key,
    required this.currentImageUrl,
    required this.selectedImageFile,
    required this.onImageSelected,
  });

  // Displays the interactive selection layout template
  void _showMediaPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusLg),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppDimensions.sm),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: AppDimensions.sm),
            ],
          ),
        );
      },
    );
  }

  // Executes the image_picker platform hardware routine
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80, // Compression layer optimization
    );

    if (image != null) {
      onImageSelected(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Evaluates memory pointer states to choose the correct image representation layer
    final ImageProvider avatarImage;
    if (selectedImageFile != null) {
      avatarImage = FileImage(selectedImageFile!);
    } else if (currentImageUrl != null && currentImageUrl!.isNotEmpty) {
      avatarImage = NetworkImage(currentImageUrl!);
    } else {
      avatarImage = const NetworkImage('https://placehold.co');
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: context.colorScheme.surface,
            backgroundImage: avatarImage,
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: context.colorScheme.primary,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: AppColors.textPrimaryDark,
                ),
                onPressed: () => _showMediaPickerBottomSheet(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
