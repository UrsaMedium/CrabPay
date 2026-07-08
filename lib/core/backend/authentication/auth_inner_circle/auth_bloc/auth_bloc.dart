import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthInnerInterface interface)
    : super(AuthStateLoggedOut(currentUser: appTempUser)) {
    // when the app is launched the initialization is emited
    on<AuthEventInitialize>((event, emit) async {
      try {
        emit(AuthStateLoading(currentUser: appTempUser));
        try {
          await interface.logOut();
        } catch (e) {
          // TODO
        }
        await interface.initialize();
        final user = await interface.getUser();

        //on first app open
        if (user == null) {
          try {
            final anonUser = await interface.signInAnonymously();
            if (anonUser == null) throw Exception();
            emit(AuthStateLoggedOut(currentUser: anonUser));
          } catch (_) {
            final localUser = appTempUser;
            emit(AuthStateLoggedOut(currentUser: localUser));
          }
          return;
        }

        //if the app is still used by anonymous user
        if (user.isAnonymous) {
          emit(AuthStateLoggedOut(currentUser: user));
          return;
        }

        //if user have not verified their email
        if (!user.isEmailVerified) {
          emit(AuthStateLoggedIn(currentUser: user));
          return;
        }

        //if alright
        emit(AuthStateLoggedIn(currentUser: user));
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: appTempUser,
            bloodyAuthException: e,
            reason: 'Bloody Authentication Failure: ${e.toString()}',
          ),
        );
      }
    });

    // when a user wants to log out
    on<AuthEventLogOut>((event, emit) async {
      emit(AuthStateLoading(currentUser: appTempUser));
      try {
        await interface.logOut();
        emit(
          AuthStateLoggedOut(
            currentUser: appTempUser,
            bloodyAuthException: null,
            reason: 'User Is Loged Out',
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: appTempUser,
            bloodyAuthException: e,
            reason: 'Some Exception. Log Out Failure: ${e.toString()}',
          ),
        );
      }
    });

    // when an user asks to reset their password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(AuthStateLoading(currentUser: appTempUser));
      try {
        await interface.sendPasswordReset(toEmail: event.email);
        emit(
          AuthStateLoggedOut(
            currentUser: appTempUser,
            bloodyAuthException: null,
            reason: 'Password Reset Email Is Sent',
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: appTempUser,
            bloodyAuthException: e,
            reason:
                'Some Exception.  Password Reset Emai Is Not Sent: ${e.toString()}',
          ),
        );
      }
    });

    // user tries to register
    on<AuthEventRegister>((event, emit) async {
      emit(AuthStateLoading(currentUser: appTempUser));
      try {
        await interface.createUser(
          email: event.email,
          password: event.password,
        );
        await interface.sendEmailVerification();
        final user = await interface.getUser();
        if (user != null) {
          emit(AuthStateLoggedIn(currentUser: user));
        } else {
          emit(
            AuthStateLoggedOut(
              currentUser: appTempUser,
              bloodyAuthException: null,
              reason:
                  'Even though the user registered, there is no user isntance: myysteriously there is no exception',
            ),
          );
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: appTempUser,
            bloodyAuthException: e,
            reason: 'Register Failur: ${e.toString()}',
          ),
        );
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(AuthStateLoading(currentUser: appTempUser));
      try {
        final user = await interface.logIn(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedIn(currentUser: user));
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: appTempUser,
            bloodyAuthException: e,
            reason: 'Log In Failure: ${e.toString()}',
          ),
        );
      }
    });
  }
}
