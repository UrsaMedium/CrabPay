import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showOnUnauthBuyToRegister(BuildContext context) {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          getIt<InnerLoggerHandler>().logBreadcrumb(
            message: 'RegisterViewDriver AuthState change',
            data: {'authState': authState},
          );
          if (authState is AuthStateLoggedIn &&
              !authState.currentUser.isAnonymous) {
            return Navigator.pop(context, true);
          }
          if (authState is AuthStateLoggedOut ||
              authState.currentUser.isAnonymous) {
            Fluttertoast.showToast(
              msg: 'Registration failed',
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: AlertDialog(
          title: Text(
            'Register to Buy',
            style: TextStyle(
              color: context.appColorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: .center,
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                TextField(
                  controller: email,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColorScheme.primaryFixed,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColorScheme.primaryFixed,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    label: Text('Email*'),
                    filled: true,
                  ),
                ),
                TextField(
                  controller: password,
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColorScheme.primaryFixed,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColorScheme.primaryFixed,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    label: Text('Password*'),
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: 100.0,
              child: TextButton(
                onPressed: () {
                  getIt<InnerLoggerHandler>().logBreadcrumb(
                    message: 'pop up registering',
                    data: {'email': email.text, 'password': password.text},
                  );
                  context.read<AuthBloc>().add(
                    AuthEventRegister(
                      email: email.text,
                      password: password.text,
                    ),
                  );
                },
                child: const Text('Register'),
              ),
            ),
            SizedBox(
              width: 100.0,
              child: TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Dismiss'),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        ),
      );
    },
  );
}
