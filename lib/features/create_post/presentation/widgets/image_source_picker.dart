import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Presentation utility helper exposing a modal interface sheet for selecting image capture channels.
///
/// Prompts the user with structured choices allowing target selections from
/// either the platform native multimedia photo gallery or the system hardware camera module.
class ImageSourcePicker {
  /// Spawns a platform safe bottom modal action dialog window holding media routes.
  ///
  /// ### Parameters:
  /// * [context] : The build anchor interface containing contextual element coordinates.
  /// * [onSourceSelected] : The return capture event callback pipeline executing after selections.
  static void show(
    BuildContext context,
    Function(ImageSource) onSourceSelected,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  onSourceSelected(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  onSourceSelected(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
