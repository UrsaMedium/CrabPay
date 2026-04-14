import 'package:crabpay/core/authentication/auth_binding_circle/auth_binding_service.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut && context.canPop()) {
          context.pop();
        }
      },
      child: SizedBox(
        height: 200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your profile:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.appColorScheme.primary,
                            ),
                          ),
                          Text(
                            appUserEmail() ?? 'If you see me. You are in limbo',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.read<AuthBloc>().add(
                        AuthEventLogOut(context: context),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.appColorScheme.primary,
                        foregroundColor: context.appColorScheme.onPrimary,
                        minimumSize: Size(0, 50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout_outlined),
                          Text(
                            '  Sign Out',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(height: 8),
                Divider(thickness: 1, color: context.appColorScheme.outline),
                Container(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
