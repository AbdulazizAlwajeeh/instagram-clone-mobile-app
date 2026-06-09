import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUp({
    required this.email,
    required this.password,
  });
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  const AuthSignIn({
    required this.email,
    required this.password,
  });
}

class AuthCheckSession extends AuthEvent {
  const AuthCheckSession();
}

class AuthSignOut extends AuthEvent {
  const AuthSignOut();
}