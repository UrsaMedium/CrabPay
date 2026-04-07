import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

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
              focusNode: _emailFocusNode,
              autofocus: true,
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
                onPressed: () {},
                child: Text('Forgot Password?'),
              ),
            ),
            Container(height: 40),
            appBigElevatedButton(text: 'Sign In', context: context),
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
            appBigElevatedButton(
              text: 'Sign Up',
              context: context,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
}
