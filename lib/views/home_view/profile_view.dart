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
        height: 300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: context.appColorScheme.outline,
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      context.read<AuthBloc>().add(AuthEventLogOut()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColorScheme.primary,
                    foregroundColor: context.appColorScheme.onPrimary,
                    minimumSize: Size(double.infinity, 50),
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
                Container(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
