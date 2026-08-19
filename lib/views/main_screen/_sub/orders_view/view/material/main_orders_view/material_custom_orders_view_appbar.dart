import 'package:crabpay/views/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/views/main_screen/_sub/orders_view/driver/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialCustomOrdersViewAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;
  final VoidCallback onBackButtonPressed;
  final VoidCallback changeSearchState;
  const MaterialCustomOrdersViewAppbar({
    super.key,
    this.height = kToolbarHeight,
    required this.onBackButtonPressed,
    required this.changeSearchState,
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
            top: MediaQuery.paddingOf(context).top,
            left: 8,
            right: 8,
          ),
          child: Builder(
            builder: (context) {
              final isSearchOpen = context.select<OrdersViewCubit, bool>(
                (cubit) => cubit.state.isSerchOpen,
              );
              final highGraphics = context.select<GlobalGraphicBloc, bool>(
                (bloc) => bloc.state.highGraphics,
              );
              return Row(
                mainAxisAlignment: .spaceBetween,
                mainAxisSize: .max,
                spacing: 4,
                children: [
                  Stack(
                    children: [
                      Material(
                        borderRadius: .circular(24),
                        clipBehavior: .antiAlias,
                        color: Colors.transparent,
                        child: BackdropFilter(
                          enabled: highGraphics,
                          filter: .blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              color: context.appColorScheme.surfaceContainerHigh
                                  .withValues(alpha: highGraphics ? .5 : .97),
                            ),
                            child: IconButton(
                              onPressed: onBackButtonPressed,
                              icon: Icon(Icons.arrow_back_rounded),
                            ),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: .topCenter,
                            end: .bottomCenter,
                            colors: [
                              context.appColorScheme.outline.withValues(
                                alpha: .2,
                              ),
                              context.appColorScheme.outline.withValues(
                                alpha: .1,
                              ),
                              Colors.transparent,
                              Colors.transparent,
                              context.appColorScheme.outline.withValues(
                                alpha: .1,
                              ),
                            ],
                          ).createShader(bounds),
                          child: Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              borderRadius: .circular(22),
                              border: .all(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Material(
                          borderRadius: .circular(24),
                          clipBehavior: .antiAlias,
                          color: Colors.transparent,
                          child: BackdropFilter(
                            enabled: highGraphics,
                            filter: .blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: .symmetric(horizontal: 16),
                              height: 46,
                              decoration: BoxDecoration(
                                color: context
                                    .appColorScheme
                                    .surfaceContainerHigh
                                    .withValues(alpha: highGraphics ? .5 : .97),
                              ),
                              child: Align(
                                alignment: .centerLeft,
                                child: Text(
                                  isSearchOpen ? 'Search' : 'Orders',
                                  style: TextStyle(
                                    color: context.appColorScheme.primary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IgnorePointer(
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: .topCenter,
                              end: .bottomCenter,
                              colors: [
                                context.appColorScheme.outline.withValues(
                                  alpha: .2,
                                ),
                                context.appColorScheme.outline.withValues(
                                  alpha: .1,
                                ),
                                Colors.transparent,
                                Colors.transparent,
                                context.appColorScheme.outline.withValues(
                                  alpha: .1,
                                ),
                              ],
                            ).createShader(bounds),
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius: .circular(22),
                                border: .all(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Material(
                        borderRadius: .circular(24),
                        clipBehavior: .antiAlias,
                        color: Colors.transparent,
                        child: BackdropFilter(
                          enabled: highGraphics,
                          filter: .blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            alignment: .centerEnd,
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              color: context.appColorScheme.surfaceContainerHigh
                                  .withValues(alpha: highGraphics ? .5 : .97),
                            ),
                            child: IconButton(
                              onPressed: changeSearchState,
                              icon: Icon(
                                isSearchOpen
                                    ? Icons.close_rounded
                                    : Icons.search_rounded,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: .topCenter,
                            end: .bottomCenter,
                            colors: [
                              context.appColorScheme.outline.withValues(
                                alpha: .2,
                              ),
                              context.appColorScheme.outline.withValues(
                                alpha: .1,
                              ),
                              Colors.transparent,
                              Colors.transparent,
                              context.appColorScheme.outline.withValues(
                                alpha: .1,
                              ),
                            ],
                          ).createShader(bounds),
                          child: Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              borderRadius: .circular(22),
                              border: .all(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
