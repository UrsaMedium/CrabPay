import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late FocusNode _emailFocusNode;
  late final TextEditingController _email;
  late FocusNode _passwordFocusNode;
  late final TextEditingController _password;
  late bool _doRedOnError;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
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
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _email.dispose();
    _password.dispose();
    _doRedOnError = false;
    super.dispose();
  }

  bool? huh = false;

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
                'Please, Sign In',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: context.appColorScheme.primaryFixedDim,
                ),
              ),
              Container(height: 10),
              Text(
                'Authorization will be happening here',
                textAlign: TextAlign.left,
              ),
              Container(height: 40),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextField(
                    controller: _email,
                    focusNode: _emailFocusNode,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
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
                      labelText: 'Email',
                      filled: true,
                    ),
                    autocorrect: false,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                  );
                },
              ),
              Container(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextField(
                    controller: _password,
                    focusNode: _passwordFocusNode,
                    autofocus: false,
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
                      labelText: 'Password',
                      filled: true,
                    ),
                    autocorrect: false,
                    obscureText: true,
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _turnOffOnLeave();
                    context.go('/login_view/password-forgot_view');
                  },
                  child: Text('Forgot Password?'),
                ),
              ),
              Container(height: 40),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (GoRouterState.of(context).uri.toString() ==
                      '/login_view') {
                    if (state is AuthStateLoggedIn) {
                      _turnOffOnLeave();
                      context.go('/');
                    } else {
                      _doRedOnError = true;
                    }
                  }
                },
                child: ElevatedButton(
                  onPressed: () async {
                    context.read<AuthBloc>().add(
                      AuthEventLogIn(
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
                    'Sign In',
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
                    child: Text(
                      'Don\'t have an account? Then',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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
                  context.go('/login_view/register_view');
                  _turnOffOnLeave();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Sign Up',
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
