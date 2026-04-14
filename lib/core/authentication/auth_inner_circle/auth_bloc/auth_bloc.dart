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
        // print('User Is Loged Out' + '_________________________________________________________________________________');
        // showScnackBarMessege(event.context, 'User Is Loged Out');
        // print('User Is Loged Out' + '_________________________________________________________________________________');
        emit(
          const AuthStateLoggedOut(
            bloodyAuthException: null,
            reason: 'User Is Loged Out',
          ),
        );
      } on Exception catch (e) {
        hideLoading();
        // print(e.toString() + '_________________________________________________________________________________');
        // showScnackBarMessege(event.context, e.toString());
        // print(e.toString() + '_________________________________________________________________________________');
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
        if (event.context.mounted) await showOnPasswordResetDialog(event.context);
        // print('Password Reset Email Is Sent' + '_________________________________________________________________________________');
        // showScnackBarMessege(event.context, 'Password Reset Email Is Sent');
        // print('Password Reset Email Is Sent' + '_________________________________________________________________________________');
        emit(
          const AuthStateLoggedOut(
            bloodyAuthException: null,
            reason: 'Password Reset Email Is Sent',
          ),
        );
      } on Exception catch (e) {
        hideLoading();
        // print(e.toString() + '_________________________________________________________________________________');
        // showScnackBarMessege(event.context, e.toString());
        // print(e.toString() + '_________________________________________________________________________________');
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
        // print('Register Success' + '_________________________________________________________________________________');
        // showScnackBarMessege(event.context, 'Register Success');
        // print('Register Success' + '_________________________________________________________________________________');
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: null,
            reason: 'Register Success',
          ),
        );
      } on Exception catch (e) {
        hideLoading();
        // print(e.toString() + '_________________________________________________________________________________');
        // showScnackBarMessege(event.context, e.toString());
        // print(e.toString() + '_________________________________________________________________________________');
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
      // print('LOGIN' + '_________________________________________________________________________________');
      // print(event.email + event.password + '___________________________');
      // print('LOGIN' + '_________________________________________________________________________________');
      try {
        final user = await interface.logIn(
          email: event.email,
          password: event.password,
        );
        if (user.isEmailVerified) {
          hideLoading();
          // print('LOGIN' + '_________________________________________________________________________________');
          // showScnackBarMessege(event.context, 'LOGIN');
          // print('LOGIN' + '_________________________________________________________________________________');
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
          // print('User Email Is Not Verified' + '_________________________________________________________________________________');
          // showScnackBarMessege(event.context, 'User Email Is Not Verified');
          // print('User Email Is Not Verified' + '_________________________________________________________________________________');
          emit(
            AuthStateLoggedOut(
              bloodyAuthException: null,
              reason: 'User Email Is Not Verified',
            ),
          );
        }
      } on Exception catch (e) {
        hideLoading();
        // print(e.toString() + '_________________________________________________________________________________');
        // showScnackBarMessege(event.context, e.toString());
        // print('Some Exception. Log In Failure' + '_________________________________________________________________________________');
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
