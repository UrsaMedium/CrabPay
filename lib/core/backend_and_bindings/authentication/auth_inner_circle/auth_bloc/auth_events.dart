import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  final BuildContext context;
  const AuthEvent({required this.context});
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize({required super.context});
}

class AuthEventSentEmailVerification extends AuthEvent {
  const AuthEventSentEmailVerification({required super.context});
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password, {required super.context});
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password, {required super.context});
}

class AuthEventForgotPassword extends AuthEvent {
  final String email;
  const AuthEventForgotPassword({required this.email, required super.context});
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut({required super.context});
}
