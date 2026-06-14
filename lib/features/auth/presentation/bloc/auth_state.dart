import 'package:flutter/foundation.dart';
import '../../../../core/app_user/domain/entities/app_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AppUser user;

  const AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}
