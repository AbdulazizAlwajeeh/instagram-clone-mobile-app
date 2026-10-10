import 'package:flutter/cupertino.dart';
import 'package:yemengram/core/localization/extensions/localization_extensions.dart';

import '../../../../core/error/failures.dart';
import '../../domain/failures/auth_failures.dart';

extension AuthFailureMessage on Failure {
  /// Transforms strongly-typed domain failures into human-readable UI strings.
  String toUserMessage(BuildContext context) {
    return switch (this) {
      // Handle specific authentication failure classes
      InvalidCredentialsFailure() =>
        context.l10n.invalidCredentialsErrorMessage,

      EmailAlreadyInUseFailure() =>
        context.l10n.emailAlreadyUsedErrorMessage,

      UsernameAlreadyInUseFailure() =>
        context.l10n.usernameAlreadyUsedErrorMessage,

      WeakPasswordFailure() =>
        'This password is too weak.',

      AuthNetworkFailure() =>
        'Connection timed out. Please check your internet and try again.',

      // Handle core global failures
      ServerFailure() =>
        'Our servers are experiencing issues. Please try again later.',

      CacheFailure() =>
        'Could not load your local session data. Please log in again.',

      // Fallback for generic AuthFailure or unhandled runtime exceptions
      _ => 'An unexpected error occurred. Please try again.',
    };
  }
}
