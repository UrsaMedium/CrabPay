import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final Exception? bloodyAuthException;
  final AppAuthUser currentUser;
  const AuthState({
    this.bloodyAuthException,
    this.currentUser = AppAuthUser.empty,
  });
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn({required super.currentUser});
}

class AuthStateLoggedOut extends AuthState {
  final String? reason;
  const AuthStateLoggedOut({
    required super.currentUser,
    super.bloodyAuthException,
    String? loadingText,
    this.reason,
  });
}
