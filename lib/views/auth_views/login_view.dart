import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_exceptions.dart';
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

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // if (state is AuthStateLoggedOut) {
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.exception.toString())));
          // }
          if (state is AuthStateLoggedOut) {
            if (state.exception is UserNotFoundException) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('User not Found')));
            } else if (state.exception is WrongPasswordException) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Wrong Passrod')));
            } else if (state.exception is GenericAuthException) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Authentication Error')));
            }
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
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
                TextField(
                  controller: _email,
                  focusNode: _emailFocusNode,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    labelText: 'Email',
                    filled: true,
                  ),
                  autocorrect: false,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                ),
                Container(height: 16),
                TextField(
                  controller: _password,
                  focusNode: _passwordFocusNode,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    labelText: 'Password',
                    filled: true,
                  ),
                  autocorrect: false,
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        context.go('/login_view/password-forgot_view'),
                    child: Text('Forgot Password?'),
                  ),
                ),
                Container(height: 40),
                ElevatedButton(
                  onPressed: () {
                      context.read<AuthBloc>().add(
                        AuthEventLogIn(_email.text, _password.text),
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
                  onPressed: () => context.go('/login_view/register_view'),
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
      ),
    );
  }
}
