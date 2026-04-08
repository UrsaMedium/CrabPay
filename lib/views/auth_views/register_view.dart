import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late FocusNode _nameTextFieldFocus;
  late FocusNode _emailTextFieldFocus;
  late FocusNode _passwordTextFieldFocus;

  @override
  void initState() {
    super.initState();
    _nameTextFieldFocus = FocusNode();
    _emailTextFieldFocus = FocusNode();
    _passwordTextFieldFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameTextFieldFocus.dispose();
    _emailTextFieldFocus.dispose();
    _passwordTextFieldFocus.dispose();
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
      child: Scaffold(
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
                'Create Account',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: context.appColorScheme.primaryFixedDim,
                ),
              ),
              Container(height: 10),
              Text('Create an account to shop, top up, and get 24/7 support.'),
              Container(height: 40),
              TextField(
                focusNode: _nameTextFieldFocus,
                autofocus: false,
                autocorrect: false,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailTextFieldFocus),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  label: Text('Name*'),
                  filled: true,
                ),
              ),
              Container(height: 16),
              TextField(
                focusNode: _emailTextFieldFocus,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => FocusScope.of(
                  context,
                ).requestFocus(_passwordTextFieldFocus),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  label: Text('Email*'),
                  filled: true,
                ),
              ),
              Container(height: 16),
              TextField(
                focusNode: _passwordTextFieldFocus,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  label: Text('Password*'),
                  filled: true,
                ),
              ),
              Container(height: 64),
              ElevatedButton(
                onPressed: () => context.go('/'),
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
                onPressed: () => context.go('/login_view'),
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
      ),
    );
  }
}
