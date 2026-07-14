import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventOnStreamUserChanged extends AuthEvent {
  final AppAuthUser user;
  const AuthEventOnStreamUserChanged(this.user);
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSentEmailVerification extends AuthEvent {
  const AuthEventSentEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn({required this.email, required this.password});
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister({required this.email, required this.password});
}

class AuthEventForgotPassword extends AuthEvent {
  final String email;
  const AuthEventForgotPassword({required this.email});
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
