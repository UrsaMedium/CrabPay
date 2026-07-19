import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/main.dart';
import 'package:crabpay/views/auth_views/register_view/material_register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterViewDriver extends StatefulWidget {
  const RegisterViewDriver({super.key});

  @override
  State<RegisterViewDriver> createState() => _RegisterViewDriverState();
}

class _RegisterViewDriverState extends State<RegisterViewDriver> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'RegisterViewDriver initState',
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
    return BlocProvider(
      create: (_) => RegisterViewCubit(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          getIt<InnerLoggerHandler>().logBreadcrumb(
            message: 'RegisterViewDriver AuthState change',
            data: {'authState': authState},
          );
          if (authState is AuthStateLoggedIn) {
            context.go('/');
          }
        },
        child: BlocBuilder<RegisterViewCubit, RegisterViewState>(
          builder: (context, viewState) {
            void onRegistering() {
              getIt<InnerLoggerHandler>().logBreadcrumb(
                message: 'RegisterViewDriver onRegistering',
                data: {
                  'email': _emailController.text,
                  'password': _passwordController.text,
                },
              );
              context.read<RegisterViewCubit>().validateAndSubmit(
                email: _emailController.text,
                password: _passwordController.text,
                onValid: ((email, password) {
                  context.read<AuthBloc>().add(
                    AuthEventRegister(email: email, password: password),
                  );
                }),
              );
            }

            void onBackButtonPressed() {
              getIt<InnerLoggerHandler>().logBreadcrumb(
                message: 'RegisterViewDriver onBackButtonPressed',
              );
              if (GoRouter.of(context).canPop()) {
                context.pop();
              }
            }

            void onCorrectingCredentials() {
              getIt<InnerLoggerHandler>().logBreadcrumb(
                message: 'RegisterViewDriver onCorrectingCredentials',
              );
              context.read<RegisterViewCubit>().clearErrors();
            }

            return MaterialRegisterView(
              emailController: _emailController,
              passwordController: _passwordController,
              isSubmitting: viewState.isSubmitting,
              emailError: viewState.emailError,
              passwordError: viewState.emailError,
              onBackButtonPressed: onBackButtonPressed,
              onCorrectingCredentials: onCorrectingCredentials,
              onRegistering: onRegistering,
            );
          },
        ),
      ),
    );
  }
}

class RegisterViewState {
  final String? emailError;
  final String? passwordError;
  final bool isSubmitting;

  const RegisterViewState({
    this.emailError,
    this.passwordError,
    this.isSubmitting = false,
  });
}

class RegisterViewCubit extends Cubit<RegisterViewState> {
  RegisterViewCubit() : super(const RegisterViewState());

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
      emit(RegisterViewState(emailError: emailErr, passwordError: passwordErr));
    } else {
      emit(const RegisterViewState(isSubmitting: true));
      onValid(email, password);
    }
  }

  void clearErrors() {
    emit(
      const RegisterViewState(
        emailError: null,
        passwordError: null,
        isSubmitting: false,
      ),
    );
  }
}
