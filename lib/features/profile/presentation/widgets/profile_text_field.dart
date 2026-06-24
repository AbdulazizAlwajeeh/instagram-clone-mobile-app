import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final bool alignLabelWithHint;
  final Widget? prefixIconWrapper;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final String? errorText;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.alignLabelWithHint = false,
    this.prefixIconWrapper,
    this.onChanged,
    this.suffixIcon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: context.textTheme.bodyMedium,
        counterStyle: maxLength != null ? context.textTheme.labelSmall : null,
        alignLabelWithHint: alignLabelWithHint,
        // Uses custom icon padding setup if supplied (crucial for multiline Bio positioning)
        prefixIcon: prefixIconWrapper ?? Icon(prefixIcon),
        suffixIcon: suffixIcon,
        errorText: errorText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.borderRadiusMd),
          ),
        ),
      ),
      validator: validator,
    );
  }
}
