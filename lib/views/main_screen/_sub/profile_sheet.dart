import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileSheetDriver extends StatefulWidget {
  const ProfileSheetDriver({super.key});

  @override
  State<ProfileSheetDriver> createState() => _ProfileSheetDriverState();
}

class _ProfileSheetDriverState extends State<ProfileSheetDriver> {
  final List<bool> isSelected = [false, true];

  void _onSignOutPressed(BuildContext context) {
    getIt<InnerLoggerHandler>().logBreadcrumb(message: 'User signed out');
    context.read<AuthBloc>().add(AuthEventLogOut());
    if (context.canPop()) {
      context.pop();
    }
  }

  void _onGraphicsToggle(BuildContext context, bool isHigh) {
    if (isHigh) {
      context.read<GlobalGraphicBloc>().add(GlobalGraphicEventSetHigh());
    } else {
      context.read<GlobalGraphicBloc>().add(GlobalGraphicEventSetLow());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialProfileSheet(
      isSelected: isSelected,
      user: context.read<AuthBloc>().state.currentUser,
      onSignOutPressed: () => _onSignOutPressed(context),
      onGraphicsToggle: (p0) => _onGraphicsToggle(context, p0),
    );
  }
}

class MaterialProfileSheet extends StatelessWidget {
  final List<bool> isSelected;
  final VoidCallback onSignOutPressed;
  final Function(bool) onGraphicsToggle;
  final AppAuthUser user;
  const MaterialProfileSheet({
    super.key,
    required this.user,
    required this.onSignOutPressed,
    required this.isSelected,
    required this.onGraphicsToggle,
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
                      Divider(
                        thickness: 1,
                        color: context.appColorScheme.outline,
                      ),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            'High Graphics',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.appColorScheme.onSurface,
                            ),
                          ),
                          Switch(
                            value: highGraphics,
                            onChanged: (bool newValue) =>
                                onGraphicsToggle(newValue),
                          ),
                        ],
                      ),
                    ],
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
