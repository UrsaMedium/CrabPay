import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/auth_views/password_forgot_view/material_password_forgot_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PasswordForgotViewDriver extends StatefulWidget {
  const PasswordForgotViewDriver({super.key});

  @override
  State<PasswordForgotViewDriver> createState() =>
      _PasswordForgotViewDriverState();
}

class _PasswordForgotViewDriverState extends State<PasswordForgotViewDriver> {
  late final TextEditingController _emailControler;

  @override
  void initState() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'PasswordForgotViewDriver initState',
    );
    _emailControler = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordForgotViewCubit(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          getIt<InnerLoggerHandler>().logBreadcrumb(
            message: 'PasswordForgotViewDriver AuthState change',
            data: {'authState': authState},
          );
          //TODO a state to know that the reset password email has benn sent
        },
        child: BlocBuilder<PasswordForgotViewCubit, PasswordForgotViewState>(
          builder: (context, viewState) {
            void onSendResetLinkPressed() {
              getIt<InnerLoggerHandler>().logBreadcrumb(
                message: 'PasswordForgotViewDriver onSendResetLinkPressed',
                data: {'email': _emailControler.text},
              );
              context.read<PasswordForgotViewCubit>().validateAndSubmit(
                email: _emailControler.text,
                onValid: (email) => context.read<AuthBloc>().add(
                  AuthEventForgotPassword(email: email),
                ),
              );
            }

            void onBackButtonPressed() {
              getIt<InnerLoggerHandler>().logBreadcrumb(
                message: 'PasswordForgotViewDriver onBackButtonPressed',
              );
              if (GoRouter.of(context).canPop()) {
                context.pop();
              }
            }

            void onCorrectingCredentials() {
              getIt<InnerLoggerHandler>().logBreadcrumb(
                message: 'PasswordForgotViewDriver onCorrectingCredentials',
              );
              context.read<PasswordForgotViewCubit>().clearErrors();
            }

            return MaterialPasswordForgotView(
              emailControler: _emailControler,
              isSubmitting: viewState.isSubmitting,
              emailError: viewState.emailError,
              onBackButtonPressed: onBackButtonPressed,
              onCorrectingCredentials: onCorrectingCredentials,
              onSendResetLinkPressed: onSendResetLinkPressed,
            );
          },
        ),
      ),
    );
  }
}

class PasswordForgotViewState {
  final String? emailError;
  final bool isSubmitting;

  const PasswordForgotViewState({this.emailError, this.isSubmitting = false});
}

class PasswordForgotViewCubit extends Cubit<PasswordForgotViewState> {
  PasswordForgotViewCubit() : super(const PasswordForgotViewState());

  void validateAndSubmit({
    required String email,
    required Function(String email) onValid,
  }) {
    String? emailErr;

    if (email.isEmpty || !email.contains('@')) {
      emailErr = 'Email is not valid';
    }
    if (emailErr != null) {
      emit(PasswordForgotViewState(emailError: emailErr));
    } else {
      emit(const PasswordForgotViewState(isSubmitting: true));
      onValid(email);
    }
  }

  void clearErrors() {
    emit(const PasswordForgotViewState(emailError: null, isSubmitting: false));
  }
}
