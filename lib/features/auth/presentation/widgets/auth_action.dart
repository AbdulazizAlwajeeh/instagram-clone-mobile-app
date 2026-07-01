import 'package:flutter/material.dart';

/// A reusable presentation sub-component encapsulating form interaction triggers.
///
/// Consolidates primary execution mechanisms and secondary navigational text links
/// into a structured layout that reacts dynamically to background process loading flags.
class AuthActionBlock extends StatelessWidget {
  /// The descriptive title text projected inside the main high-contrast button canvas.
  final String primaryButtonText;

  /// The call-to-action string mapped onto the flat baseline toggle text element.
  final String secondaryButtonText;

  /// Operational state flag that shifts visual assets and locks pointer tap mechanics during remote transit.
  final bool isLoading;

  /// Context callback trigger targeted for primary data validation and transaction dispatches.
  final VoidCallback? onPrimaryPressed;

  /// Context callback trigger targeted for alternative interface or navigation form transformations.
  final VoidCallback? onSecondaryPressed;

  /// Instantiates a layout interaction block with configured actions and visibility modes.
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
      // Restricts core footprint to minimize structural overflow tendencies.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // Spreads buttons horizontally to match layout grid profiles.
      children: [
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isLoading ? null : onPrimaryPressed,
          // Enforces component lockouts to avoid execution stacking during network calls.
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ), // Enforces appropriate spatial thickness limits.
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ), // Renders standard progress layouts during asynchronous transits.
                )
              : Text(primaryButtonText),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: isLoading ? null : onSecondaryPressed,
          // Disables relative redirection links if an active workflow is processing.
          child: Text(secondaryButtonText),
        ),
      ],
    );
  }
}
