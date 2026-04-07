import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class PasswordForgotView extends StatefulWidget {
  const PasswordForgotView({super.key});

  @override
  State<PasswordForgotView> createState() => _PasswordForgotViewState();
}

class _PasswordForgotViewState extends State<PasswordForgotView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
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
              autocorrect: false,
              autofocus: false,

              decoration: InputDecoration(
                filled: true,
                label: Text('Email'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            Container(height: 40),
            appBigElevatedButton(text: 'Send Reset Link', context: context),
          ],
        ),
      ),
    );
  }
}
