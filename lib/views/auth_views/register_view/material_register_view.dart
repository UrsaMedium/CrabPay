import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialRegisterView extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;
  final bool isSubmitting;
  final VoidCallback onRegistering;
  final VoidCallback onBackButtonPressed;
  final VoidCallback onCorrectingCredentials;
  const MaterialRegisterView({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.emailError,
    this.passwordError,
    required this.isSubmitting,
    required this.onRegistering,
    required this.onBackButtonPressed,
    required this.onCorrectingCredentials,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            onBackButtonPressed();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: .stretch,
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
                  controller: emailController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => onCorrectingCredentials(),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: emailError != null
                            ? context.appColorScheme.error
                            : context.appColorScheme.primaryFixed,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: emailError != null
                            ? context.appColorScheme.error
                            : context.appColorScheme.primaryFixed,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    label: Text('Email*'),
                    filled: true,
                  ),
                );
              },
            ),
            Container(height: 16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return TextField(
                  controller: passwordController,
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (_) => onCorrectingCredentials(),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: passwordError != null
                            ? context.appColorScheme.error
                            : context.appColorScheme.primaryFixed,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: passwordError != null
                            ? context.appColorScheme.error
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
            ElevatedButton(
              onPressed: () {
                onRegistering();
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
              onPressed: () => onBackButtonPressed(),
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
    );
  }
}
