import 'package:crabpay/core/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/authentication/auth_outer_circle/firebase_outer_interface.dart';

class AuthBindingService implements AuthInnerInterface {
  final AuthInnerInterface interface;
  AuthBindingService({required this.interface});

  factory AuthBindingService.fireBase() =>
      AuthBindingService(interface: (FirebaseOuterInterface()));

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => interface.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => interface.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      interface.logIn(email: email, password: password);

  @override
  Future<void> logOut() => interface.logOut();

  @override
  Future<void> sendEmailVerification() => interface.sendEmailVerification();

  @override
  Future<void> initialize() => interface.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      interface.sendPasswordReset(toEmail: toEmail);
}
