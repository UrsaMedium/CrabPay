import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileSheetDriver extends StatefulWidget {
  const ProfileSheetDriver({super.key});

  @override
  State<ProfileSheetDriver> createState() => _ProfileSheetDriverState();
}

class _ProfileSheetDriverState extends State<ProfileSheetDriver> {
  void _onSignOutPressed(BuildContext context) {
    context.read<AuthBloc>().add(AuthEventLogOut());
    if (context.canPop()) {
      context.pop();
    }
  }

  void _onAdminPressed(BuildContext context) {
    context.push(AppRoutes.adminTools.path);
  }

  @override
  Widget build(BuildContext context) {
    return _MaterialProfileSheet(
      user: context.read<AuthBloc>().state.currentUser,
      onSignOutPressed: () => _onSignOutPressed(context),
      onAdminPressed: () => _onAdminPressed(context),
      isAdmin: context.read<AuthBloc>().state.currentUser.isAdmin,
    );
  }
}

class _MaterialProfileSheet extends StatelessWidget {
  final bool isAdmin;
  final VoidCallback onSignOutPressed;
  final VoidCallback onAdminPressed;
  final AppAuthUser user;
  const _MaterialProfileSheet({
    required this.user,
    required this.onSignOutPressed,
    required this.isAdmin,
    required this.onAdminPressed,
  });

  @override
  Widget build(BuildContext context) {
    final highGraphics = context.select<GlobalGraphicBloc, bool>(
      (bloc) => bloc.state.highGraphics,
    );
    return Wrap(
      children: [
        Material(
          borderRadius: BorderRadius.vertical(top: .circular(24)),
          clipBehavior: .antiAlias,
          color: Colors.transparent,
          child: BackdropFilter(
            enabled: highGraphics,
            filter: .blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: context.appColorScheme.surfaceContainer.withValues(
                  alpha: highGraphics ? .5 : .95,
                ),
              ),
              height: 200,
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: .topCenter,
                      end: .bottomCenter,
                      colors: [
                        context.appColorScheme.outline.withValues(alpha: .2),
                        context.appColorScheme.outline.withValues(alpha: .1),
                        Colors.transparent,
                        Colors.transparent,
                        context.appColorScheme.outline.withValues(alpha: .1),
                      ],
                    ).createShader(bounds),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: .circular(27),
                        border: .all(color: Colors.white),
                      ),
                    ),
                  ),
                  Center(
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
                                  backgroundColor:
                                      context.appColorScheme.primary,
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
                          Divider(
                            thickness: 1,
                            color: context.appColorScheme.outline,
                          ),
                          if (isAdmin)
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text(
                                  'Admin Menu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: context.appColorScheme.onSurface,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => onAdminPressed(),
                                  icon: Icon(Icons.settings),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
