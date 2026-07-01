import 'package:flutter/material.dart';

/// A simple presentation header component that displays the application branding.
///
/// Consolidates the typography and styling constraints for the application's
/// primary welcoming logotype title layout.
class AuthHeader extends StatelessWidget {
  /// Instantiates a stateless visual title text block.
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Yemengram',
      textAlign: TextAlign.center,
      // Centers the title across horizontal canvas alignments.
      style: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight
            .bold, // Enforces high visual weight emphasis on brand entry layout.
      ),
    );
  }
}
