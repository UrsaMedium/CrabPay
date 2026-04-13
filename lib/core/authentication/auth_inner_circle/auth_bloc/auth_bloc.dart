import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/views/dialogs/on_login_dialog.dart';
import 'package:crabpay/views/dialogs/on_password_forgot.dart';
import 'package:crabpay/views/dialogs/on_regester_dialog.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthInnerInterface interface)
    : super(const AuthStateUninitialized()) {
    // when the app is launched the initialization is emited
    on<AuthEventInitialize>((event, emit) async {
      showLoading(event.context);
      await interface.initialize();
      final user = interface.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            bloodyAuthException: null,
            reason: 'No User Found',
          ),
        );
        hideLoading();
      } else if (!user.isEmailVerified) {
        try {
          await interface.logOut();
          hideLoading();
          emit(
            AuthStateLoggedOut(
              bloodyAuthException: null,
              reason: 'The User Email Is Not Verified',
            ),
          );
        } on Exception catch (e) {
          hideLoading();
          emit(
            AuthStateLoggedOut(
              bloodyAuthException: e,
              reason:
                  'Some Exception. Tried To Log Out - Email Is Not Verified',
            ),
          );
        }
      } else {
        hideLoading();
        emit(AuthStateLoggedIn(user: user));
      }
    });

    // when an user wants to log out
    on<AuthEventLogOut>((event, emit) async {
      showLoading(event.context);
      try {
        await interface.logOut();
        hideLoading();
        emit(
          const AuthStateLoggedOut(
            bloodyAuthException: null,
            reason: 'User Is Loged Out',
          ),
        );
      } on Exception catch (e) {
        hideLoading();
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: e,
            reason: 'Some Exception. Log Out Failure',
          ),
        );
      }
    });

    // when an user asks to reset their password
    on<AuthEventForgotPassword>((event, emit) async {
      showLoading(event.context);
      try {
        await interface.sendPasswordReset(toEmail: event.email);
        hideLoading();
        if (event.context.mounted) showOnPasswordResetDialog(event.context);
        emit(
          const AuthStateLoggedOut(
            bloodyAuthException: null,
            reason: 'Password Reset Email Is Sent',
          ),
        );
      } on Exception catch (e) {
        hideLoading();
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: e,
            reason: 'Some Exception.  Password Reset Emai Is Not Sent',
          ),
        );
      }
    });

    // user tries to register
    on<AuthEventRegister>((event, emit) async {
      showLoading(event.context);
      try {
        await interface.createUser(
          email: event.email,
          password: event.password,
        );
        await interface.sendEmailVerification();
        hideLoading();
        if (event.context.mounted) await showOnRegisterDialog(event.context);
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: null,
            reason: 'Register Success',
          ),
        );
      } on Exception catch (e) {
        hideLoading();
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: e,
            reason: 'Some Exception. Register Failur',
          ),
        );
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      showLoading(event.context);
      try {
        final user = await interface.logIn(
          email: event.email,
          password: event.password,
        );
        if (user.isEmailVerified) {
          hideLoading();
          emit(AuthStateLoggedIn(user: user));
        } else {
          hideLoading();
          if (event.context.mounted) {
            bool? sendVerification = await showOnLoginDialog(event.context);
            if (event.context.mounted) showLoading(event.context);
            if (sendVerification == true) interface.sendEmailVerification();
          }
          await interface.logOut();
          hideLoading();
          emit(
            AuthStateLoggedOut(
              bloodyAuthException: null,
              reason: 'User Email Is Not Verified',
            ),
          );
        }
      } on Exception catch (e) {
        hideLoading();
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: e,
            reason: 'Some Exception. Log In Failure',
          ),
        );
      }
    });
  }
}
