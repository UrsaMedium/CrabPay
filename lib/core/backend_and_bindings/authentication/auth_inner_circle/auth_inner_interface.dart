import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';

abstract class AuthInnerInterface {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({required String email, required String password});
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}
