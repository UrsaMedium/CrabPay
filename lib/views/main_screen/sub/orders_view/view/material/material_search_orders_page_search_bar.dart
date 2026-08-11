import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/dialogs/custom_syncfusion_date_range_dialog.dart';
import 'package:flutter/material.dart';

class MaterialSearchOrdersPageSearchBar extends StatelessWidget {
  const MaterialSearchOrdersPageSearchBar({super.key});

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
              onTap: () async {
                final dateRange = await openDateRangePicker(context);
                debugPrint('${dateRange?.startDate} - ${dateRange?.endDate}');
              },
              child: Container(
                height: 36,
                // width: 46,
                decoration: BoxDecoration(
                  color: context.appColorScheme.surfaceContainerHigh.withValues(
                    alpha: context.highGraphics ? .5 : .97,
                  ),
                ),
                child: Stack(
                  alignment: .center,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        Text(
                          'From:',
                          style: TextStyle(
                            color: context.appColorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'To:',
                          style: TextStyle(
                            color: context.appColorScheme.onSurface,
                          ),
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
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: .circular(22),
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
