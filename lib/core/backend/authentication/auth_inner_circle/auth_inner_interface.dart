import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';

abstract class AuthInnerInterface {
  Future<void> initialize();
  Future<AppAuthUser?> getUser();
  Future<AppAuthUser?> signInAnonymously();
  Future<AppAuthUser> logIn({required String email, required String password});
  Future<AppAuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
  Stream<AppAuthUser> get userStream;
}
