import 'package:crabpay/core/authentication/auth_binding_circle/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final Exception? bloodyAuthException;
  const AuthState({this.bloodyAuthException});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user});
}

  class AuthStateLoggedOut extends AuthState with EquatableMixin {
    final String? reason;
    const AuthStateLoggedOut({
      required super.bloodyAuthException,
      String? loadingText, this.reason,
    });

    @override
    List<Object?> get props => [bloodyAuthException, reason];
  }