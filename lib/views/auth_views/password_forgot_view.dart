import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
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

  @override
  void initState() {
    super.initState();
    _emailControler = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            TextField(
              controller: _emailControler,
              autocorrect: false,
              autofocus: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                label: Text('Email'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            Container(height: 40),
            ElevatedButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                  AuthEventForgotPassword(email: _emailControler.text),
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
          ],
        ),
      ),
    );
  }
}
