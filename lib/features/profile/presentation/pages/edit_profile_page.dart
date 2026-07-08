import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/core/theme/app_dimensions.dart';
import 'package:yemengram/core/theme/theme_extensions.dart';
import 'package:yemengram/features/profile/domain/entities/user_profile.dart';
import 'package:yemengram/features/profile/presentation/widgets/profile_avatar_picker.dart';
import 'package:yemengram/features/profile/presentation/widgets/profile_save_button.dart';
import '../bloc/edit_profile_bloc.dart';
import '../bloc/edit_profile_event.dart';
import '../bloc/edit_profile_state.dart';
import '../widgets/profile_text_field.dart';

/// Form page enabling interactive modification of an authenticated profile structure.
///
/// Coordinates text controllers, file picker callbacks, validation rules, and business streams.
class EditProfilePage extends StatefulWidget {
  /// The static historical user profile data snapshot used to prefill input forms.
  final UserProfile user;

  /// Constructs a stateful [EditProfilePage] wrapping user initialization contexts.
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Global form key state container managing inline validation routines
  final _formKey = GlobalKey<FormState>();

  // initial profile data
  late final String? _userAvatar;
  File? _pickedImage;
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _bioController = TextEditingController(text: widget.user.bio);
    _userAvatar = widget.user.avatarUrl;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  /// Conditionally displays availability verification icons inside the trailing input decoration frame.
  Widget? _buildUsernameSuffixIcon(EditProfileState state) {
    if (state is EditProfileUsernameChecking) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (state is EditProfileUsernameAvailable) {
      return const Icon(Icons.check_circle_rounded, color: Colors.green);
    }
    if (state is EditProfileUsernameTaken) {
      return const Icon(Icons.cancel_rounded, color: Colors.red);
    }
    return null;
  }

  /// Evaluates current state conditions and fields validation status before broadcasting updates.
  void _saveProfile() {
    if (context.read<EditProfileBloc>().state is EditProfileUsernameTaken) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      context.read<EditProfileBloc>().add(
        EditProfileSubmitted(
          username: _usernameController.text.trim(),
          fullName: _fullNameController.text.trim(),
          bio: _bioController.text.trim(),
          imageFile: _pickedImage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: context.textTheme.titleLarge),
      ),
      body: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
            Navigator.pop(context, true);
          }
          if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- PROFILE PICTURE SECTION ---
                  ProfileAvatarPicker(
                    currentImageUrl: _userAvatar,
                    selectedImageFile: _pickedImage,
                    onImageSelected: (file) {
                      setState(() {
                        _pickedImage = file;
                      });
                    },
                  ),
                  const SizedBox(height: AppDimensions.xl),

                  // --- FULL NAME FIELD ---
                  ProfileTextField(
                    controller: _fullNameController,
                    labelText: 'Full Name',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // --- USERNAME FIELD ---
                  ProfileTextField(
                    controller: _usernameController,
                    labelText: 'Username',
                    prefixIcon: Icons.alternate_email,
                    onChanged: (value) {
                      context.read<EditProfileBloc>().add(
                        EditProfileUsernameChanged(username: value),
                      );
                    },
                    suffixIcon: _buildUsernameSuffixIcon(state),
                    errorText: state is EditProfileUsernameTaken
                        ? 'This username is already taken'
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username cannot be empty';
                      }
                      if (value.contains(' ')) {
                        return 'Username cannot contain spaces';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // --- BIO FIELD ---
                  ProfileTextField(
                    controller: _bioController,
                    labelText: 'Bio',
                    prefixIcon: Icons.description_outlined,
                    maxLines: 4,
                    maxLength: 150,
                    alignLabelWithHint: true,
                    prefixIconWrapper: const Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(Icons.description_outlined),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // --- SAVE BUTTON ---
                  state is EditProfileSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : ProfileSaveButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _saveProfile();
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
