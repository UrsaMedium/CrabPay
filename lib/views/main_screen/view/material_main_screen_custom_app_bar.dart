import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MaterialMainScreenCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;
  final bool isAdmin;
  final bool isLoggedIn;
  final VoidCallback onAdminPressed;
  final VoidCallback onOrdersPressed;
  final Function(Offset) onProfileIconPressed;
  final GlobalKey profileIconButtonKey;
  const MaterialMainScreenCustomAppBar({
    super.key,
    this.height = kToolbarHeight,
    required this.isAdmin,
    required this.isLoggedIn,
    required this.onAdminPressed,
    required this.onOrdersPressed,
    required this.onProfileIconPressed,
    required this.profileIconButtonKey,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
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
                          color: context.appColorScheme.surfaceContainerHigh
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
              Row(
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
                  if (isAdmin)
                    IconButton(
                      onPressed: onAdminPressed,
                      icon: Icon(Icons.settings),
                    ),
                  if (isLoggedIn)
                    IconButton(
                      onPressed: onOrdersPressed,
                      icon: Icon(Icons.cases_rounded),
                    ),
                  isLoggedIn
                      ? IconButton(
                          onPressed: () => onProfileIconPressed(Offset(0, 0)),
                          icon: Icon(Icons.account_circle_rounded),
                        )
                      : IconButton(
                          key: profileIconButtonKey,
                          onPressed: () {
                            final renderBox =
                                profileIconButtonKey.currentContext
                                        ?.findRenderObject()
                                    as RenderBox?;
                            if (renderBox == null) {
                              getIt<InnerLoggerHandler>().logInfo(
                                message: 'Login Button Error',
                              );
                              Fluttertoast.showToast(msg: 'Login Button Error');
                              return;
                            }
                            final position = renderBox.localToGlobal(
                              Offset.zero,
                            );
                            final centerOffset = Offset(
                              position.dx + (renderBox.size.width / 2),
                              position.dy + (renderBox.size.height / 2),
                            );
                            onProfileIconPressed(centerOffset);
                          },
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
