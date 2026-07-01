import 'package:flutter/material.dart';

/// A reusable presentation text input field engineered for credential accumulation fields.
///
/// Standardizes structural borders, labels, validation pathways, and accessibility tracking
/// parameters uniformly across onboarding layouts.
class AuthTextField extends StatelessWidget {
  /// The local editing supervisor tasked with capturing and exposing the active input text buffer tracking stream.
  final TextEditingController controller;

  /// The static floating informational label mapped into the structural decoration track.
  final String labelText;

  /// Toggles raw visual character obscuring filters to safeguard discrete input strings like passwords.
  final bool obscureText;

  /// Controls the interactive read/write layout states and pointer interaction thresholds for the field.
  final bool enabled;

  /// The programmatic software configuration profile dictating the layout configuration of the virtual keyboard engine.
  final TextInputType? keyboardType;

  /// Evaluation hook fired by wrapping form contexts to run validation tests against the string block input parameters.
  final String? Function(String?)? validator;

  /// Instantiates a text input field framework with customizable input parameters and layout states.
  const AuthTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border:
            const OutlineInputBorder(), // Establishes clean outline geometry tracks across all input states.
      ),
    );
  }
}
