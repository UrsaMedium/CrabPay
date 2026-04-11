import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/dialogs/on_login_dialog.dart';
import 'package:crabpay/core/dialogs/on_password_forgot.dart';
import 'package:crabpay/core/dialogs/on_regester_dialog.dart';
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
  // late FocusNode _emailFocusNode;
  // late final TextEditingController _email;
  // late FocusNode _passwordFocusNode;
  // late final TextEditingController _password;

  // @override
  // void initState() {
  //   super.initState();
  //   _emailFocusNode = FocusNode();
  //   _passwordFocusNode = FocusNode();
  //   _email = TextEditingController();
  //   _password = TextEditingController();
  // }

  // @override
  // void dispose() {
  //   _emailFocusNode.dispose();
  //   _passwordFocusNode.dispose();
  //   _email.dispose();
  //   _password.dispose();
  //   super.dispose();
  // }
  bool? huh = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.isLoading) {
          showLoading(context);
        } else {
          hideLoading();
          showScnackBarMessege(context, state.toString());
          if (state is AuthStateNeedsVerification &&
              GoRouterState.of(context).uri.path == '/login_view') {
            huh = await showOnLoginDialog(context);
          } else if (state is AuthStateRegistering &&
              GoRouterState.of(context).uri.path ==
                  '/login_view/register_view' && state.exception == null) {
            await showOnRegisterDialog(context);
          } else if (state is AuthStateForgotPassword && state.exception == null) {
            await showOnPasswordResetDialog(context);
          } else if (state is AuthStateLoggedIn) {
            context.go('/');
          }
        }
      },
      builder: (context, state) {
        if (state is AuthStateNeedsVerification) {
          context.read<AuthBloc>().add(const AuthEventLogOut());
        } else if (huh == true) {
          huh = false;
          context.read<AuthBloc>().add(AuthEventSentEmailVerification());
          context.go('/');
        } else if (state is AuthStateRegistering) {
          context.read<AuthBloc>().add(const AuthEventLogOut());
          context.go('/');
        } else if (state is AuthStateForgotPassword) {
          context.read<AuthBloc>().add(const AuthEventLogOut());
          context.go('/');
        }

        return actualLoginUi(context, state);
      },
    );
  }
}

Widget actualLoginUi(BuildContext context, AuthState state) {
  FocusNode emailFocusNode = FocusNode();
  TextEditingController email = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController password = TextEditingController();

  return Scaffold(
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
            controller: email,
            focusNode: emailFocusNode,
            autofocus: false,
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
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
          ),
          Container(height: 16),
          TextField(
            controller: password,
            focusNode: passwordFocusNode,
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
              onPressed: () => context.go('/login_view/password-forgot_view'),
              child: Text('Forgot Password?'),
            ),
          ),
          Container(height: 40),
          ElevatedButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                AuthEventLogIn(email.text, password.text),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
  );
}
