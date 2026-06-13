import 'package:flutter/material.dart';

class AuthActionBlock extends StatelessWidget {
  final String primaryButtonText;
  final String secondaryButtonText;
  final bool isLoading;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const AuthActionBlock({
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.isLoading,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isLoading ? null : onPrimaryPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(primaryButtonText),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: isLoading ? null : onSecondaryPressed,
          child: Text(secondaryButtonText),
        ),
      ],
    );
  }
}
