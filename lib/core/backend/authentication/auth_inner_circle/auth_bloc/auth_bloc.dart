import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthInnerInterface _interface;
  StreamSubscription<AppAuthUser>? _userSubscription;
  AuthBloc(this._interface) : super(const AuthStateLoading()) {
    // when the app is launched the initialization is emited
    on<AuthEventInitialize>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await _interface.initialize();
        await _userSubscription?.cancel();

        _userSubscription = _interface.userStream.listen((user) {
          add(AuthEventOnStreamUserChanged(user));
        });

      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: state.currentUser,
            bloodyAuthException: e,
            reason: 'Bloody Authentication Failure: ${e.toString()}',
          ),
        );
      }
    });

    on<AuthEventOnStreamUserChanged>((event, emit) async {
      final user = event.user;

      if (user.isEmpty) {
        try {
          final anonUser = await _interface.signInAnonymously();
          if (anonUser != null && anonUser.isNotEmpty) {
            emit(
              AuthStateLoggedOut(currentUser: anonUser, reason: 'Anon session'),
            );
          } else {
            throw Exception('Server returned empty anon user');
          }
        } catch (e) {
          emit(
            AuthStateLoggedOut(
              currentUser: AppAuthUser.empty,
              bloodyAuthException: e is Exception ? e : Exception(e.toString()),
              reason: 'Faild to initiate anon user ',
            ),
          );
        }
        return;
      }

      if (user.isAnonymous) {
        emit(AuthStateLoggedOut(currentUser: user, reason: 'Anon session'));
        return;
      }

      emit(AuthStateLoggedIn(currentUser: user));
    });

    // when a user wants to log out
    on<AuthEventLogOut>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await _interface.logOut();
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: state.currentUser,
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
        await _interface.sendPasswordReset(toEmail: event.email);
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: state.currentUser,
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
        await _interface.createUser(
          email: event.email,
          password: event.password,
        );
        await _interface.sendEmailVerification();
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: state.currentUser,
            bloodyAuthException: e,
            reason: 'Register Failure: ${e.toString()}',
          ),
        );
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await _interface.logIn(email: event.email, password: event.password);
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            currentUser: state.currentUser,
            bloodyAuthException: e,
            reason: 'Log In Failure: ${e.toString()}',
          ),
        );
      }
    });
  }
  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
