import 'package:flutter/foundation.dart';
import '../../../../core/app_user/domain/entities/app_user.dart';

/// Base state class governing the active application authentication status.
///
/// This class is marked `@immutable` to guarantee thread-safe state distribution pipelines
/// across state management emission streams.
@immutable
abstract class AuthState {
  /// Instantiates an unmodifiable baseline state framework.
  const AuthState();
}

/// Initial default state configuration before any authentication verification routine executes.
class AuthInitial extends AuthState {}

/// Emitted while asynchronous authentication workflows are executing on remote servers.
///
/// Signals presentation components to switch their active layouts over to processing
/// view metrics (e.g., locking input fields and spinning progress circles).
class AuthLoading extends AuthState {}

/// Emitted when a session verification or sign-in sequence completes successfully.
///
/// Passes a validated [AppUser] domain entity down towards visual tree contexts to
/// open access gates into internal functional dashboards.
class AuthSuccess extends AuthState {
  /// The active authenticated user domain entity profile structure.
  final AppUser user;

  /// Creates a finalized, successful tracking state containing user profile parameters.
  const AuthSuccess(this.user);
}

/// Emitted when a new account generation pipeline clears remote backend validation filters.
///
/// Triggers visual navigation actions or success popups to guide users toward activation.
class SignUpSuccess extends AuthState {}

/// Emitted when an operational authorization sequence breaks down or encounters validation blocks.
///
/// Captures readable troubleshooting strings to let presentation layers display user-facing alerts.
class AuthFailure extends AuthState {
  /// The descriptive error message outlining the authentication fault.
  final String message;

  /// Creates a detailed authentication failure barrier carrying raw message details.
  const AuthFailure(this.message);
}
