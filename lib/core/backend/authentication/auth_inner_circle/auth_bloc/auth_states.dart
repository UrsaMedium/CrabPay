import 'package:crabpay/core/backend/authentication/auth_binding_circle/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final Exception? bloodyAuthException;
  final AuthUser currentUser;
  const AuthState({
    this.bloodyAuthException,
    required this.currentUser,
  });
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading({
    required super.currentUser,
  });
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn({
    required super.currentUser,
  });
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final String? reason;
  const AuthStateLoggedOut({
    required super.currentUser,
    super.bloodyAuthException,
    String? loadingText,
    this.reason,
  });

  @override
  List<Object?> get props => [bloodyAuthException, reason];
}
