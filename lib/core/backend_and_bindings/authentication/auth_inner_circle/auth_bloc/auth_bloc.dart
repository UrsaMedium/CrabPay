import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthInnerInterface interface)
    : super(const AuthStateUninitialized()) {
    // when the app is launched the initialization is emited
    on<AuthEventInitialize>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await interface.initialize();
        final user = await interface.getUser();

        //on first app open
        if (user == null) {
          final anonUser = await interface.signInAnonymously();
          emit(AuthStateLoggedInAnonymously(currentUser: anonUser));
          return;
        }

        //if the app is still used by anonymous user
        if (user.isAnonymous) {
          emit(AuthStateLoggedInAnonymously(currentUser: user));
          return;
        }

        //if user have not verified their email
        if (!user.isEmailVerified) {
          emit(AuthStateLoggedInWithUnverifiedEmail(currentUser: user));
          return;
        }

        //if alright
        emit(AuthStateLoggedIn(currentUser: user));
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: e,
            reason: 'Bloody Authentication Failure: ${e.toString()}',
          ),
        );
      }
    });

    // when a user wants to log out
    on<AuthEventLogOut>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await interface.logOut();
        emit(
          const AuthStateLoggedOut(
            bloodyAuthException: null,
            reason: 'User Is Loged Out',
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: e,
            reason: 'Some Exception. Log Out Failure: ${e.toString()}',
          ),
        );
      }
    });

    // when an user asks to reset their password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await interface.sendPasswordReset(toEmail: event.email);
        emit(
          const AuthStateLoggedOut(
            bloodyAuthException: null,
            reason: 'Password Reset Email Is Sent',
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: e,
            reason:
                'Some Exception.  Password Reset Emai Is Not Sent: ${e.toString()}',
          ),
        );
      }
    });

    // user tries to register
    on<AuthEventRegister>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await interface.createUser(
          email: event.email,
          password: event.password,
        );
        await interface.sendEmailVerification();
        final user = await interface.getUser();
        if (user != null) {
          emit(AuthStateLoggedInWithUnverifiedEmail(currentUser: user));
        } else {
          emit(
            AuthStateLoggedOut(
              bloodyAuthException: null,
              reason:
                  'Even though the user registered, there is no user isntance: myysteriously there is no exception',
            ),
          );
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: e,
            reason: 'Register Failur: ${e.toString()}',
          ),
        );
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(AuthStateLoading());
      try {
        final user = await interface.logIn(
          email: event.email,
          password: event.password,
        );
        if (user.isEmailVerified) {
          emit(AuthStateLoggedIn(currentUser: user));
        } else {
          emit(AuthStateLoggedInWithUnverifiedEmail(currentUser: user));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            bloodyAuthException: e,
            reason: 'Log In Failure: ${e.toString()}',
          ),
        );
      }
    });
  }
}
