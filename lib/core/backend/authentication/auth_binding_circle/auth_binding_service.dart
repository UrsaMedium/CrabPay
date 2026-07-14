import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_outer_circle/supabase_outer_auth_interface.dart';

class AuthBindingService implements AuthInnerInterface {
  final AuthInnerInterface interface;
  AuthBindingService({required this.interface});

  factory AuthBindingService.fireBase() =>
      AuthBindingService(interface: (SupabaseOuterAuthInterface()));

  @override
  Future<AppAuthUser> createUser({
    required String email,
    required String password,
  }) => interface.createUser(email: email, password: password);

  @override
  Future<AppAuthUser?> getUser() => interface.getUser();

  @override
  Future<AppAuthUser> logIn({
    required String email,
    required String password,
  }) => interface.logIn(email: email, password: password);

  @override
  Future<void> logOut() => interface.logOut();

  @override
  Future<void> sendEmailVerification() => interface.sendEmailVerification();

  @override
  Future<void> initialize() => interface.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      interface.sendPasswordReset(toEmail: toEmail);

  @override
  Future<AppAuthUser?> signInAnonymously() => interface.signInAnonymously();

  @override
  Stream<AppAuthUser> get userStream => interface.userStream;
}
