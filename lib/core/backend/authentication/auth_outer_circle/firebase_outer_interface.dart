import 'package:crabpay/core/backend/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_exceptions.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crabpay/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show EmailAuthProvider, FirebaseAuth, FirebaseAuthException, User;
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class FirebaseOuterInterface implements AuthInnerInterface {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null && currentUser.isAnonymous) {
        final credentialsOfAnonUser = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await currentUser.linkWithCredential(credentialsOfAnonUser);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final user = await getUser();
      if (user != null) {
        return user;
      } else {
        throw NoUserSignInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use' ||
          e.code == 'credential-already-in-use') {
        throw EmailAlreadyTakenException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<bool> _checkIfAdmin(User user) async {
    final tokenResult = await user.getIdTokenResult();
    return tokenResult.claims?['admin'] == true;
  }

  @override
  Future<AuthUser?> getUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // final currentUsere = FirebaseAuth.instance.currentUser?.getIdToken(true);
      if (user != null) {
        final isAdmin = await _checkIfAdmin(user);
        return AuthUser.fromFirebase(user, isAdmin: true); //TODO
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthUser?> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      final anonUser = FirebaseAuth.instance.currentUser;
      if (anonUser != null) {
        return AuthUser.fromFirebase(anonUser, isAdmin: true); //TODO
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = await getUser();
      if (user != null) {
        return user;
      } else {
        throw NoUserSignInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw NoUserSignInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.isAnonymous) {
      await user.sendEmailVerification();
    } else {
      throw NoUserSignInException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      providerApple: kDebugMode
          ? const AppleDebugProvider()
          : const AppleAppAttestProvider(),
      providerWeb: kDebugMode
          ? WebDebugProvider()
          : ReCaptchaV3Provider('your-recaptcha-v3-site-key'),
    );
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
