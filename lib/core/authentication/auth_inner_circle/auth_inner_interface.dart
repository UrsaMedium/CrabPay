abstract class AuthInnerInterface {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({required String email, required String password});
  Future<AuthUser> createUser({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String email});
}
