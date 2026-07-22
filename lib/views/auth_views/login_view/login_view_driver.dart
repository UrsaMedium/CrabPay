import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/auth_views/login_view/material_login_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class LoginViewDriver extends StatefulWidget {
  const LoginViewDriver({super.key});

  @override
  State<LoginViewDriver> createState() => _LoginViewDriverState();
}

class _LoginViewDriverState extends State<LoginViewDriver> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'LoginViewDriver initState',
    );
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        getIt<InnerLoggerHandler>().logBreadcrumb(
          message: 'LoginViewDriver onPopInvokedWithResult',
          data: {'didPop': didPop, 'result': result},
        );
        if (didPop) {
          return;
        }
        !Navigator.of(context).canPop() ? context.go('/') : context.pop();
      },
      child: BlocProvider(
        create: (_) => LoginViewCubit(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, authState) {
            getIt<InnerLoggerHandler>().logBreadcrumb(
              message: 'LoginViewDriver AuthState change',
              data: {'authState': authState},
            );
            if (authState is AuthStateLoggedIn) {
              context.go('/');
            }
            if (authState is AuthStateLoggedOut) {
              if (authState.bloodyAuthException != null) {
                Fluttertoast.showToast(
                  msg: 'Wrong credentials. Please try again.',
                  toastLength: Toast.LENGTH_LONG,
                );
                context.read<LoginViewCubit>().setErrors(
                  emailError: 'Invalid email or password',
                  passwordError: 'Invalid email or password',
                );
              }
            }
          },
          child: BlocBuilder<LoginViewCubit, LoginViewState>(
            builder: (context, viewState) {
              void onSignInPressed() {
                getIt<InnerLoggerHandler>().logBreadcrumb(
                  message: 'LoginViewDriver onSignInPressed',
                  data: {
                    'email': _emailController.text,
                    'password': _passwordController.text,
                  },
                );
                context.read<LoginViewCubit>().validateAndSubmit(
                  email: _emailController.text,
                  password: _passwordController.text,
                  onValid: (email, password) {
                    context.read<AuthBloc>().add(
                      AuthEventLogIn(email: email, password: password),
                    );
                  },
                );
              }

              void onBackButtonPressed() {
                getIt<InnerLoggerHandler>().logBreadcrumb(
                  message: 'LoginViewDriver onBackButtonPressed',
                );
                if (GoRouter.of(context).canPop()) {
                  context.pop();
                }
              }

              void onCorrectingCredentials() {
                getIt<InnerLoggerHandler>().logBreadcrumb(
                  message: 'LoginViewDriver onCorrectingCredentials',
                );
                context.read<LoginViewCubit>().clearErrors();
              }

              void onSignUpPressed() {
                getIt<InnerLoggerHandler>().logBreadcrumb(
                  message: 'LoginViewDriver onSignUpPressed',
                );
                context.read<LoginViewCubit>().clearErrors();
                context.push('/login_view/register_view');
              }

              void onForgotPasswordPressed() {
                getIt<InnerLoggerHandler>().logBreadcrumb(
                  message: 'LoginViewDriver onForgotPasswordPressed',
                );
                context.read<LoginViewCubit>().clearErrors();
                context.push('/login_view/password-forgot_view');
              }

              if (defaultTargetPlatform == TargetPlatform.iOS && !kIsWeb) {
                //TODO cupertino view
              }

              return MaterialLoginView(
                emailController: _emailController,
                passwordController: _passwordController,
                isSubmitting: viewState.isSubmitting,
                onForgotPassword: onForgotPasswordPressed,
                onSignIn: onSignInPressed,
                onSignUp: onSignUpPressed,
                passwordError: viewState.passwordError,
                emailError: viewState.emailError,
                onBackButtonPressed: onBackButtonPressed,
                onCorrectingCredentials: onCorrectingCredentials,
              );
            },
          ),
        ),
      ),
    );
  }
}

class LoginViewState {
  final String? emailError;
  final String? passwordError;
  final bool isSubmitting;

  const LoginViewState({
    this.emailError,
    this.passwordError,
    this.isSubmitting = false,
  });
}

class LoginViewCubit extends Cubit<LoginViewState> {
  LoginViewCubit() : super(const LoginViewState());

  void validateAndSubmit({
    required String email,
    required String password,
    required Function(String email, String password) onValid,
  }) {
    String? emailErr;
    String? passwordErr;

    if (email.isEmpty || !email.contains('@')) {
      emailErr = 'Email is not alid';
    }
    if (password.isEmpty || password.length < 6) {
      passwordErr = 'Password is not valid';
    }
    if (emailErr != null || passwordErr != null) {
      emit(LoginViewState(emailError: emailErr, passwordError: passwordErr));
    } else {
      emit(const LoginViewState(isSubmitting: true));
      onValid(email, password);
    }
  }

  void setErrors({String? emailError, String? passwordError}) {
    emit(
      LoginViewState(
        emailError: emailError,
        passwordError: passwordError,
        isSubmitting: false,
      ),
    );
  }

  void clearErrors() {
    emit(
      const LoginViewState(
        emailError: null,
        passwordError: null,
        isSubmitting: false,
      ),
    );
  }
}
