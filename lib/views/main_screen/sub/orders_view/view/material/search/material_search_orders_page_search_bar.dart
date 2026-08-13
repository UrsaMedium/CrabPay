import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialSearchOrdersPageSearchBar extends StatelessWidget {
  final VoidCallback onSearchBarPressed;
  const MaterialSearchOrdersPageSearchBar({
    super.key,
    required this.onSearchBarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: .circular(14),
      clipBehavior: .antiAlias,
      color: Colors.transparent,
      child: Stack(
        children: [
          BackdropFilter(
            enabled: context.highGraphics,
            filter: .blur(sigmaX: 12, sigmaY: 12),
            child: GestureDetector(
              onTap: onSearchBarPressed,
              child: Container(
                height: 56,
                // width: 46,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.appColorScheme.surfaceContainerHigh.withValues(
                    alpha: context.highGraphics ? .5 : .97,
                  ),
                ),
                child: Stack(
                  alignment: .center,
                  children: [
                    Column(
                      spacing: 4,
                      children: [
                        Text(
                          'Tap Here to Pick Dates',
                          style: TextStyle(
                            color: context.appColorScheme.primary,
                            fontWeight: .bold,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final fromDate = context
                                .select<OrdersViewCubit, DateTime?>(
                                  (cubit) => cubit.state.fromDate,
                                );
                            final toDate = context
                                .select<OrdersViewCubit, DateTime?>(
                                  (cubit) => cubit.state.toDate,
                                );
                            return Row(
                              mainAxisAlignment: .spaceAround,
                              children: [
                                Text(
                                  'From: ${fromDate == null ? '' : dateConversion(fromDate.toString()).substring(0, 12)}',
                                  style: TextStyle(
                                    color: context.appColorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'To: ${toDate == null ? '' : dateConversion(toDate.toString()).substring(0, 12)}',
                                  style: TextStyle(
                                    color: context.appColorScheme.onSurface,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
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
                  context.appColorScheme.outline.withValues(alpha: .2),
                  context.appColorScheme.outline.withValues(alpha: .1),
                  Colors.transparent,
                  Colors.transparent,
                  context.appColorScheme.outline.withValues(alpha: .1),
                ],
              ).createShader(bounds),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: .circular(14),
                  border: .all(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
