import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_event.dart';
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
  String? _functionType;
  final TextEditingController _functionTypeController = TextEditingController();
  String? _currency;
  final TextEditingController _currencyController = TextEditingController();
  late final List<ProductField>? _appPoductFields;
  List<Widget> _fieldsWithOptions = [];
  final Map<ProductField, bool> _priceDomainDimensionFields = {};
  ProductField? _priceRangeField;
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
    context.read<DatabaseBloc>().add(DatabaseEventFetchAllCurrencies());
    super.initState();
  }

  @override
  void dispose() {
    _functionTypeController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  void reset() {
    setState(() {
      _priceDomainDimensionFields.clear();
      _isRangeChosen = false;
      _priceRangeField = null;
    });
  }

  List<Widget> _buildOptions(ProductField aField) {
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

  List<Widget> _buildFieldsWithOptions(List<ProductField> fields) {
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
            //currencies  dropdown menu
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
              child: BlocBuilder<DatabaseBloc, DatabaseState>(
                builder: (context, state) {
                  bool enableCurreniesDropdownMenu = false;
                  final List<DropdownMenuEntry<String>> currencies = [];
                  if (state.states == DatabaseStates.currenciesFetched) {
                    enableCurreniesDropdownMenu = true;
                    for (var currencyTable in state.currencies!) {
                      currencies.add(
                        DropdownMenuEntry(
                          value: currencyTable.name,
                          label: 'From ${currencyTable.name}',
                        ),
                      );
                    }
                  } else {
                    enableCurreniesDropdownMenu = false;
                  }
                  return DropdownMenu<String>(
                    enabled: enableCurreniesDropdownMenu,
                    expandedInsets: EdgeInsets.zero,
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: context.appColorScheme.primary,
                          width: 1,
                        ),
                      ),
                    ),
                    onSelected: (value) => _currency = value,
                    controller: _currencyController,
                    dropdownMenuEntries: currencies,
                  );
                },
              ),
            ),
            // function type dropdown menu
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
              child: DropdownMenu<String>(
                expandedInsets: EdgeInsets.zero,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: context.appColorScheme.primary,
                      width: 1,
                    ),
                  ),
                ),
                onSelected: (value) => _functionType = value,
                controller: _functionTypeController,
                dropdownMenuEntries: <DropdownMenuEntry<String>>[
                  DropdownMenuEntry(
                    value: 'constant',
                    label: 'Constant function',
                  ),
                  DropdownMenuEntry(value: 'linear', label: 'Linear function'),
                ],
              ),
            ),
            // range picking field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 2,
                alignment: .start,
                children: _fieldsToBeChosenAsRange(),
              ),
            ),
            // domain picking fields
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
                        bool gateKeeper = true;
                        if (_functionType == null) {
                          Fluttertoast.showToast(
                            msg:
                                'Please, choose a type of the product function',
                          );
                          gateKeeper = false;
                        } else {
                          if (_currency == null) {
                            Fluttertoast.showToast(
                              msg:
                                  'Please, choose what currency will be applied to the product',
                            );
                            gateKeeper = false;
                          } else {
                            if (_priceRangeField == null) {
                              Fluttertoast.showToast(
                                msg: 'Please, choose a range field',
                              );
                              gateKeeper = false;
                            } else {
                              if (_functionType == 'linear' &&
                                  _priceRangeField!.fieldName != 'InputField') {
                                Fluttertoast.showToast(
                                  msg:
                                      'Linear function MUST have \'User Custom Input\' field as the range',
                                );
                                gateKeeper = false;
                              }
                              if (_functionType == 'constant' &&
                                  _priceRangeField!.fieldName == 'InputField') {
                                Fluttertoast.showToast(
                                  msg:
                                      'Constant function CANNOT have \'User Custom Input\' field as the range',
                                );
                                gateKeeper = false;
                              }
                            }
                          }
                        }

                        if (gateKeeper) {
                          Map<ProductField, String> priceSpcaeToSend = {};
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
                              functionType: _functionType,
                              currency: _currency,
                            ),
                          );
                          // dispose();
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
