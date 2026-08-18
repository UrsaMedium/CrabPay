import 'package:crabpay/views/custom_ui_elements/ui_utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Future<PickerDateRange?> openDateRangePicker(BuildContext context) async {
  final PickerDateRange? result = await showDialog<PickerDateRange>(
    context: context,
    builder: (context) {
      return const CustomSyncfusionDateRangeDialog();
    },
  );
  return result;
}

class CustomSyncfusionDateRangeDialog extends StatefulWidget {
  const CustomSyncfusionDateRangeDialog({super.key});

  @override
  State<CustomSyncfusionDateRangeDialog> createState() =>
      _CustomSyncfusionDateRangeDialogState();
}

class _CustomSyncfusionDateRangeDialogState
    extends State<CustomSyncfusionDateRangeDialog> {
  PickerDateRange? _selectedRange;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: .circular(24)),
      clipBehavior: .antiAlias,
      insetPadding: const .symmetric(horizontal: 16, vertical: 20),
      backgroundColor: context.appColorScheme.surfaceContainer,
      child: SizedBox(
        height: 356,
        width: 256,
        child: Column(
          children: [
            SfDateRangePicker(
              backgroundColor: Colors.transparent,
              selectionMode: .range,
              showNavigationArrow: true,
              rangeSelectionColor:
                  context.appColorScheme.surfaceContainerHighest,
              startRangeSelectionColor: context.appColorScheme.primary,
              endRangeSelectionColor: context.appColorScheme.primary,
              todayHighlightColor: context.appColorScheme.tertiary,
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.transparent,
                textAlign: .center,
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: .w600,
                  color: context.appColorScheme.onSurface,
                ),
              ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1,
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  textStyle: TextStyle(
                    color: context.appColorScheme.primary,
                    fontWeight: .bold,
                  ),
                ),
              ),
              onSelectionChanged: (args) {
                if (args.value is PickerDateRange) {
                  setState(() {
                    _selectedRange = args.value;
                  });
                }
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.pop(_selectedRange);
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
