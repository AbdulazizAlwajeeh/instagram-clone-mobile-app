import 'package:flutter/foundation.dart';

/// Base event class defining user intents and session commands for the authentication subsystem.
///
/// This class is marked `@immutable` to guarantee safe handling and prevent data mutations
/// inside state management pipelines.
@immutable
abstract class AuthEvent {
  /// Instantiates an unmodifiable baseline event framework.
  const AuthEvent();
}

/// Dispatched from the registration form to request new account provisioning.
///
/// Carries the necessary demographic fields required by the remote backend to
/// instantiate an independent profile block.
class AuthSignUp extends AuthEvent {
  /// The user-provided electronic mail endpoint string.
  final String email;

  /// The secure unencrypted credentials string chosen by the user.
  final String password;

  /// The unique public identifier handle selected by the user.
  final String username;

  /// Creates a frozen event carrier containing all user registration parameters.
  const AuthSignUp({
    required this.email,
    required this.password,
    required this.username,
  });
}

/// Dispatched from the login interface to authenticate an existing profile context.
///
/// Supplies credentials arrays down towards core domain verification gateways.
class AuthSignIn extends AuthEvent {
  /// The electronic mail identity string tracking the target account.
  final String email;

  /// The secure access token key associated with the matching record.
  final String password;

  /// Creates a frozen event carrier containing validation access keys.
  const AuthSignIn({required this.email, required this.password});
}

/// Dispatched during initial application boots to evaluate ongoing session persistence.
///
/// Triggers non-interactive repository calls to recover existing cached validation tokens
/// before rendering initial landing pages.
class AuthCheckSession extends AuthEvent {
  /// Instantiates a startup session validation request.
  const AuthCheckSession();
}

/// Dispatched from settings or dashboard menus to terminate the active user session.
///
/// Triggers complete token eviction sequences across local filesystems and remote databases.
class AuthSignOut extends AuthEvent {
  /// Instantiates an explicit user-driven logout command.
  const AuthSignOut();
}
