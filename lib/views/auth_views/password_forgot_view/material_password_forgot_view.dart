import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class MaterialPasswordForgotView extends StatelessWidget {
  final TextEditingController emailControler;
  final bool isSubmitting;
  final String? emailError;
  final VoidCallback onSendResetLinkPressed;
  final VoidCallback onBackButtonPressed;
  final VoidCallback onCorrectingCredentials;
  const MaterialPasswordForgotView({
    super.key,
    required this.emailControler,
    required this.isSubmitting,
    this.emailError,
    required this.onSendResetLinkPressed,
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
              'Reset Password',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: context.appColorScheme.primary,
              ),
            ),
            Container(height: 10),
            Text(
              'Enter your email address and we\'ll send you instructions to reset your password',
            ),
            Container(height: 40),
            TextField(
              controller: emailControler,
              autocorrect: false,
              keyboardType: .emailAddress,
              onChanged: (_) => onCorrectingCredentials(),
              decoration: InputDecoration(
                filled: true,
                label: Text('Email'),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: emailError != null
                        ? context.appColorScheme.error
                        : context.appColorScheme.primaryFixed,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: emailError != null
                        ? context.appColorScheme.error
                        : context.appColorScheme.primaryFixed,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            Container(height: 40),
            ElevatedButton(
              onPressed: isSubmitting ? null : onSendResetLinkPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColorScheme.primary,
                foregroundColor: context.appColorScheme.onPrimary,
                minimumSize: Size(double.infinity, 50),
              ),
              child: isSubmitting
                  ? CircularProgressIndicator()
                  : Text(
                      'Send Reset Link',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
