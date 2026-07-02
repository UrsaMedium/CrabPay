import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final Exception? bloodyAuthException;
  final AuthUser? currentUser;
  const AuthState({this.bloodyAuthException, this.currentUser});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn({required super.currentUser});
}

class AuthStateLoggedInWithUnverifiedEmail extends AuthState {
  const AuthStateLoggedInWithUnverifiedEmail({required super.currentUser});
}

class AuthStateLoggedInAnonymously extends AuthState {
  const AuthStateLoggedInAnonymously({required super.currentUser});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final String? reason;
  const AuthStateLoggedOut({
    required super.bloodyAuthException,
    String? loadingText,
    this.reason,
  });

  @override
  List<Object?> get props => [bloodyAuthException, reason];
}
