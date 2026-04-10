import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthInnerInterface interface)
    : super(const AuthStateUninitialized(isLoading: true)) {
    // when the app is launched the initialization is emited
    on<AuthEventInitialize>((event, emit) async {
      await interface.initialize();
      final user = interface.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    // when an unauthorized user tries to perfom authorazied only action
    on<AuthEventNotAuthorized>((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isLoading: false));
    });

    // when an user wants to log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await interface.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    // when an user asks to reset their password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ),
      );
      final email = event.email;
      if (email == null) {
        return; // user went to forgot-password screen
      }

      // reset email sent
      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ),
      );

      bool didSendEmail;
      Exception? exception;
      try {
        await interface.sendEmailVerification();
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(
        AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ),
      );
    });

    // user tries to register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await interface.createUser(email: email, password: password);
        await interface.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Authorizing',
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await interface.logIn(email: email, password: password);
        if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventSentEmailVerification>((event, emit) async {
      await interface.sendEmailVerification();
      emit(state);
    });
  }
}
