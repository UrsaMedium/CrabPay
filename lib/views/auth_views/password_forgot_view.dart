import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PasswordForgotView extends StatefulWidget {
  const PasswordForgotView({super.key});

  @override
  State<PasswordForgotView> createState() => _PasswordForgotViewState();
}

class _PasswordForgotViewState extends State<PasswordForgotView> {
  late final TextEditingController _emailControler;
  late bool _doRedOnError;

  @override
  void initState() {
    super.initState();
    _emailControler = TextEditingController();
    _doRedOnError = false;
  }

  void _turnOffOnLeave() {
    _emailControler.clear();
    _doRedOnError = false;
  }

  @override
  void dispose() {
    _emailControler.dispose();
    _doRedOnError = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                _turnOffOnLeave();
                context.pop();
              }
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Reset Password',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: context.appColorScheme.primaryFixedDim,
                ),
              ),
              Container(height: 10),
              Text(
                'Enter your email address and we\'ll send you instructions to reset your password',
              ),
              Container(height: 40),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextField(
                    controller: _emailControler,
                    autocorrect: false,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => _doRedOnError = false,
                    decoration: InputDecoration(
                      filled: true,
                      label: Text('Email'),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _doRedOnError
                              ? context.appColorScheme.onError
                              : context.appColorScheme.primaryFixed,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _doRedOnError
                              ? context.appColorScheme.onError
                              : context.appColorScheme.primaryFixed,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                  );
                },
              ),
              Container(height: 40),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (GoRouterState.of(context).uri.toString() ==
                      '/login_view/password-forgot_view') {
                    if (state.bloodyAuthException == null) {
                      context.go('/login_view');
                    } else {
                      _doRedOnError = true;
                    }
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthEventForgotPassword(
                        email: _emailControler.text,
                        context: context,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColorScheme.primary,
                    foregroundColor: context.appColorScheme.onPrimary,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Send Reset Link',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
