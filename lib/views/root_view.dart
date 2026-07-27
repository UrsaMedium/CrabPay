import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/views/app_routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    // GlobalLoadingScreen().show;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // GlobalLoadingScreen().show;
        // if (state is AuthStateLoading) {
        //   context.go(AppRoutes.root.path);
        // }
        // if (state is! AuthStateLoading) {
        //   context.push(AppRoutes.home.path);
        // }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // GlobalLoadingScreen().show;
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.push(AppRoutes.home.path),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }
}
