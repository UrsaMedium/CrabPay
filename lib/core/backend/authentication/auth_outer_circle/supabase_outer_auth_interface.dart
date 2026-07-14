import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_exceptions.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/supabase/supabase_conf.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class SupabaseOuterAuthInterface implements AuthInnerInterface {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<AppAuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      var currentUser = _supabase.auth.currentUser;

      if (currentUser == null) {
        final anonRes = await _supabase.auth.signInAnonymously();
        currentUser = anonRes.user;
      }

      if (currentUser != null && currentUser.isAnonymous) {
        // Upgrade anonymous user to permanent
        final response = await _supabase.auth.updateUser(
          UserAttributes(email: email, password: password),
        );
        if (response.user == null) throw NoUserSignInException();
      } else {
        // Standard signup
        final response = await _supabase.auth.signUp(
          email: email,
          password: password,
        );

        if (response.user == null) throw NoUserSignInException();

        // If signup succeeds but session is null, email confirmation is still blocking them on the VPS side.
        if (response.session == null) {
          debugPrint(
            'Auth Warning: User created, but session is null. Check GOTRUE_MAILER_AUTOCONFIRM on your VPS.',
          );
          throw NoUserSignInException();
        }
      }

      final user = await getUser();
      if (user != null) return user;

      throw NoUserSignInException();
    } on AuthException catch (e) {
      debugPrint('Supabase AuthException: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Generic Registration Error: $e');
      throw GenericAuthException();
    }
  }

  @override
  Future<AppAuthUser?> getUser() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return _mapToInnerCircle(user);
    }
    return null;
  }

  @override
  Future<AppAuthUser?> signInAnonymously() async {
    try {
      final response = await _supabase.auth.signInAnonymously();
      final anonUser = response.user;
      return anonUser != null ? _mapToInnerCircle(anonUser) : null;
    } on AuthException catch (e) {
      if (e.code == 'anonymous_provider_disabled') {
        debugPrint(
          'CRITICAL: Anonymous signins are disabled on the Supabase backend, you idiot!',
        );
      }
      debugPrint('Supabase Anon SignIn Exception: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Wow, Some Anon SignIn Error: $e');
      throw GenericAuthException();
    }
  }

  @override
  Future<AppAuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final gotUser = await getUser();
        if (gotUser != null) {
          return gotUser;
        }
      }
      throw NoUserSignInException();
    } on AuthException catch (e) {
      debugPrint('Supabase Login Exception: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Generic Login Error: $e');
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async => await _supabase.auth.signOut();

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseAccessConf['url']!,
        publishableKey: supabaseAccessConf['publishableKey']!,
      );
    } catch (e) {
      debugPrint('Supabase init caught: $e');
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    await _supabase.auth.resetPasswordForEmail(toEmail);
  }

  AppAuthUser _mapToInnerCircle(User user) {
    final bool isAdminFlag = user.appMetadata['role'] == 'admin';
    final bool isVerified =
        user.emailConfirmedAt != null ||
        (user.userMetadata?['email_verified'] == true);

    return AppAuthUser(
      id: user.id,
      email: user.email,
      isEmailVerified: isVerified,
      isAnonymous: user.isAnonymous,
      isAdmin: isAdminFlag,
      isLimbo: false,
    );
  }

  Exception _handleAuthException(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('weak')) return WeakPasswordAuthException();
    if (message.contains('already')) return EmailAlreadyTakenException();
    if (message.contains('invalid login') || message.contains('credentials')) {
      return WrongPasswordException();
    }
    if (message.contains('not found')) return UserNotFoundException();
    return GenericAuthException();
  }

  @override
  Stream<AppAuthUser> get userStream {
    return _supabase.auth.onAuthStateChange.asyncMap((authState) async {
      final event = authState.event;
      final supabaseUser = authState.session?.user;

      if (event == AuthChangeEvent.initialSession && supabaseUser == null) {
        final currentUser = _supabase.auth.currentUser;
        if (currentUser != null) {
          return _mapToInnerCircle(currentUser);
        }
      }

      if (supabaseUser == null) {
        try {
          final anonResult = await _supabase.auth.signInAnonymously();
          if (anonResult.user != null) {
            return _mapToInnerCircle(anonResult.user!);
          }
        } catch (e) {
          debugPrint('Failed to auto-sign in anonymously on stream: $e');
        }
        return AppAuthUser.empty;
      }

      return _mapToInnerCircle(supabaseUser);
    }).distinct();
  }
}
