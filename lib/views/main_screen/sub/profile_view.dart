import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileViewDriver extends StatefulWidget {
  const ProfileViewDriver({super.key});

  @override
  State<ProfileViewDriver> createState() => _ProfileViewDriverState();
}

class _ProfileViewDriverState extends State<ProfileViewDriver> {
  void _onSignOutPressed(BuildContext context) {
    context.read<AuthBloc>().add(AuthEventLogOut());
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialProfileView(
      user: context.read<AuthBloc>().state.currentUser,
      onSignOutPressed: () => _onSignOutPressed(context),
    );
  }
}

class MaterialProfileView extends StatelessWidget {
  final VoidCallback onSignOutPressed;
  final AppAuthUser user;
  const MaterialProfileView({
    super.key,
    required this.user,
    required this.onSignOutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const .only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            border: .all(
              color: context.appColorScheme.surfaceContainerLow.withValues(
                alpha: .5,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: const .only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: BackdropFilter(
              filter: .blur(sigmaX: 8, sigmaY: 8),
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
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
                                  Text('${user.email}'),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: onSignOutPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.appColorScheme.primary,
                                foregroundColor:
                                    context.appColorScheme.onPrimary,
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
                        Divider(
                          thickness: 1,
                          color: context.appColorScheme.outline,
                        ),
                        Container(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
