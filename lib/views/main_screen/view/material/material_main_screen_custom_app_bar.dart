import 'package:crabpay/core/backend/connection_monitoring/inner_monitor/connection_monitor_cubit.dart';
import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/views/main_screen/driver/main_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialMainScreenCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;
  final VoidCallback onSettingsPressed;
  final VoidCallback onOrdersPressed;
  final VoidCallback onProfileIconPressed;
  const MaterialMainScreenCustomAppBar({
    super.key,
    this.height = kToolbarHeight,
    required this.onSettingsPressed,
    required this.onOrdersPressed,
    required this.onProfileIconPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<MainScreenCubit, bool>(
      (cubit) => cubit.state.isLoggedIn,
    );
    final profileIconButtonKey = context
        .read<MainScreenCubit>()
        .state
        .profileIconButtonKey;
    final connectionStatus = context.select<ConnectionMonitorCubit, bool>(
      (cubit) => cubit.state.isOnline,
    );
    return Stack(
      children: [
        Container(
          height: MediaQuery.paddingOf(context).top * 2 + 4,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 2,
            left: 8,
            right: 8,
          ),
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  final highGraphics = context.select<GlobalGraphicBloc, bool>(
                    (bloc) => bloc.state.highGraphics,
                  );
                  return Material(
                    borderRadius: .circular(24),
                    clipBehavior: .antiAlias,
                    color: Colors.transparent,
                    child: BackdropFilter(
                      enabled: highGraphics,
                      filter: .blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color:
                              (connectionStatus
                                      ? context
                                            .appColorScheme
                                            .surfaceContainerHigh
                                      : context.appColorScheme.errorContainer)
                                  .withValues(alpha: highGraphics ? .5 : .97),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: .circular(24),
                    border: .all(color: Colors.white),
                  ),
                ),
              ),
              !connectionStatus
                  ? Center(
                      heightFactor: 1.3,
                      child: Text(
                        context.l10n.noConnection,
                        style: TextStyle(
                          color: context.appColorScheme.onErrorContainer,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            '🦀 Crab Pay',
                            style: TextStyle(
                              color: context.appColorScheme.primary,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Spacer(flex: 1),
                        IconButton(
                          onPressed: onSettingsPressed,
                          icon: Icon(Icons.settings),
                        ),
                        if (isLoggedIn)
                          IconButton(
                            onPressed: onOrdersPressed,
                            icon: Icon(Icons.cases_rounded),
                          ),
                        isLoggedIn
                            ? IconButton(
                                onPressed: onProfileIconPressed,
                                icon: Icon(Icons.account_circle_rounded),
                              )
                            : IconButton(
                                key: profileIconButtonKey,
                                onPressed: onProfileIconPressed,
                                icon: Icon(Icons.account_circle_outlined),
                              ),
                        SizedBox(width: 8),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
