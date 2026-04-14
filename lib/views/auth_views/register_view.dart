import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late FocusNode _nameTextFieldFocus;
  late FocusNode _emailTextFieldFocus;
  late FocusNode _passwordTextFieldFocus;
  late TextEditingController _email;
  late TextEditingController _password;
  late bool _doRedOnError;

  @override
  void initState() {
    super.initState();
    _nameTextFieldFocus = FocusNode();
    _emailTextFieldFocus = FocusNode();
    _passwordTextFieldFocus = FocusNode();
    _email = TextEditingController();
    _password = TextEditingController();
    _doRedOnError = false;
  }

  void _turnOffOnLeave() {
    setState(() {
      _email.clear();
      _password.clear();
      _doRedOnError = false;
    });
  }

  @override
  void dispose() {
    _nameTextFieldFocus.dispose();
    _emailTextFieldFocus.dispose();
    _passwordTextFieldFocus.dispose();
    _email.dispose();
    _password.dispose();
    _doRedOnError = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _doRedOnError = true;
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
                'Create Account',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: context.appColorScheme.primaryFixedDim,
                ),
              ),
              Container(height: 10),
              Text(
                'Create an account to shop, top up your ballance, and get support.',
              ),
              Container(height: 40),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextField(
                    controller: _email,
                    focusNode: _emailTextFieldFocus,
                    autocorrect: false,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => _doRedOnError = false,
                    onSubmitted: (_) {
                      FocusScope.of(
                        context,
                      ).requestFocus(_passwordTextFieldFocus);
                    },
                    decoration: InputDecoration(
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
                      label: Text('Email*'),
                      // errorText: _doRedOnError ? 'yo' : null,
                      filled: true,
                    ),
                  );
                },
              ),
              Container(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextField(
                    controller: _password,
                    focusNode: _passwordTextFieldFocus,
                    autocorrect: false,
                    obscureText: true,
                    onChanged: (_) => _doRedOnError = false,
                    decoration: InputDecoration(
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
                      label: Text('Password*'),
                      filled: true,
                    ),
                  );
                },
              ),
              Container(height: 64),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (GoRouterState.of(context).uri.toString() ==
                      '/login_view/register_view') {
                    if (state.bloodyAuthException == null) {
                      context.go('/');
                    } else {
                      _doRedOnError = true;
                      _email.clear();
                      _password.clear();
                    }
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthEventRegister(
                        _email.text,
                        _password.text,
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
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              Container(height: 11),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: context.appColorScheme.outline,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('You have one already? Then'),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: context.appColorScheme.outline,
                    ),
                  ),
                ],
              ),
              Container(height: 11),
              ElevatedButton(
                onPressed: () {
                  _turnOffOnLeave();
                  context.go('/login_view');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
