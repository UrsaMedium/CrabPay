import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:flutter/material.dart';

class MaterialLoginView extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;
  final bool isSubmitting;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onForgotPassword;
  final VoidCallback onBackButtonPressed;
  final VoidCallback onCorrectingCredentials;

  const MaterialLoginView({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.emailError,
    this.passwordError,
    required this.isSubmitting,
    required this.onSignIn,
    required this.onSignUp,
    required this.onForgotPassword,
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
              context.l10n.pleaseSignIn,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: context.appColorScheme.primary,
              ),
            ),
            SizedBox(height: 10),
            Text(
              context.l10n.authorizationWillBeHappeningHere,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 40),
            TextField(
              controller: emailController,
              keyboardType: .emailAddress,
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
                labelText: context.l10n.email,
                filled: true,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
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
                labelText: context.l10n.password,
                filled: true,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  onForgotPassword();
                },
                child: Text(context.l10n.forgotPassword),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: isSubmitting ? null : onSignIn,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: context.appColorScheme.primary,
                foregroundColor: context.appColorScheme.onPrimary,
              ),
              child: isSubmitting
                  ? const CircularProgressIndicator()
                  :  Text(
                      context.l10n.signIn,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider(color: context.appColorScheme.outline)),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(context.l10n.dontHaveAnAccount),
                ),
                Expanded(child: Divider(color: context.appColorScheme.outline)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onSignUp,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                context.l10n.signUp,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
