import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class PriceSpaceMapingView extends StatefulWidget {
  const PriceSpaceMapingView({super.key});

  @override
  State<PriceSpaceMapingView> createState() => _PriceSpaceMapingViewState();
}

class _PriceSpaceMapingViewState extends State<PriceSpaceMapingView> {
  late final List<AppProductField>? _appPoductFields;
  List<Widget> _fieldsWithOptions = [];
  final Map<AppProductField, bool> _priceDomainDimensionFields = {};
  AppProductField? _priceRangeField;
  bool _isRangeChosen = false;

  @override
  void initState() {
    _appPoductFields = context.read<AdminBloc>().state.appProductFields;
    if (_appPoductFields != null) {
      for (var field in _appPoductFields) {
        _priceDomainDimensionFields[field] = false;
      }
    } else {
      Fluttertoast.showToast(msg: 'ERROR no AppProduct or AppProductFields');
      context.pop();
    }
    super.initState();
  }

  void reset() {
    setState(() {
      _priceDomainDimensionFields.clear();
      _isRangeChosen = false;
      _priceRangeField = null;
    });
  }

  List<Widget> _buildOptions(AppProductField aField) {
    List<Widget> result = [];
    for (var option in aField.expectedData!) {
      result.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          child: Text(option),
        ),
      );
    }
    return result;
  }

  List<Widget> _buildFieldsWithOptions(List<AppProductField> fields) {
    List<Widget> result = [];
    bool localBoolly = false;
    for (var field in fields) {
      localBoolly =
          (field.fieldName == _priceRangeField?.fieldName ||
          field.expectedData == null);
      result.add(
        AbsorbPointer(
          absorbing: localBoolly,
          child: Opacity(
            opacity: localBoolly ? 0.5 : 1,
            child: Card(
              elevation: 3,
              clipBehavior: .antiAlias,
              color: context.appColorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Checkbox(
                      fillColor: WidgetStateColor.resolveWith((state) {
                        if (state.contains(WidgetState.selected)) {
                          return context.appColorScheme.primary;
                        } else {
                          return context.appColorScheme.outline;
                        }
                      }),
                      tristate: false,
                      value: _priceDomainDimensionFields[field] ?? false,
                      onChanged: (value) {
                        setState(() {
                          _priceDomainDimensionFields[field] = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(field.fieldName),
                      ),
                    ),
                    Expanded(child: Column(children: _buildOptions(field))),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return result;
  }

  List<Widget> _fieldsToBeChosenAsRange() {
    List<Widget> result = [
      AnimatedContainer(
        duration: Durations.long1,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          // color: _isRangeChosen ? context.appColorScheme.surfaceContainerLowest : null,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: _isRangeChosen
                  ? context.appColorScheme.primary.withValues(alpha: 0.4)
                  : Colors.transparent,
              blurRadius: _isRangeChosen ? 8 : 0,
              offset: _isRangeChosen ? const Offset(0, 4) : Offset.zero,
            ),
          ],
        ),
        child: ActionChip.elevated(
          elevation: 5,
          backgroundColor: context.appColorScheme.surfaceContainerLowest,
          shadowColor: Colors.transparent,
          onPressed: !_isRangeChosen ? null : () => reset(),
          label: Text('Reset'),
        ),
      ),
    ];
    for (var field in _appPoductFields!) {
      result.add(
        Wrap(
          children: [
            ActionChip.elevated(
              disabledColor: (field.fieldName == _priceRangeField?.fieldName)
                  ? context.appColorScheme.primaryContainer
                  : null,
              onPressed: (_isRangeChosen || field.expectedData == null)
                  ? null
                  : () {
                      setState(() {
                        _isRangeChosen = true;
                        _priceRangeField = field;
                      });
                    },
              label: Text(field.fieldName),
            ),
          ],
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _fieldsWithOptions = _buildFieldsWithOptions(_appPoductFields!);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 2,
                alignment: .start,
                children: _fieldsToBeChosenAsRange(),
              ),
            ),
            AbsorbPointer(
              absorbing: !_isRangeChosen,
              child: Opacity(
                opacity: !_isRangeChosen ? 0.5 : 1,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverList.builder(
                      itemCount: _fieldsWithOptions.length,
                      itemBuilder: (context, index) =>
                          _fieldsWithOptions[index],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: .end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (GoRouter.of(context).canPop()) {
                          context.pop();
                        }
                      },
                      child: Text('Back'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Map<AppProductField, String> priceSpcaeToSend = {};
                        if (_priceRangeField != null) {
                          priceSpcaeToSend[_priceRangeField!] = 'range';
                          _priceDomainDimensionFields.remove(_priceRangeField);
                          for (var field in _priceDomainDimensionFields.keys) {
                            if (_priceDomainDimensionFields[field]!) {
                              priceSpcaeToSend[field] = 'domain';
                            }
                          }
                          context.read<AdminBloc>().add(
                            AdminEventSubmitsPriceDimensions(
                              priceDimensions: priceSpcaeToSend,
                            ),
                          );
                          context.go(
                            '/add_complete_product_product_view/add_product_fields_view/price_space_maping_view/price_space_fill_view',
                          );
                        }
                      },
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
