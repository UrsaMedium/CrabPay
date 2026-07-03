import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/dialogs/on_database_item_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class FieldAdminPanelView extends StatefulWidget {
  static const routeName = 'field_admin_panel_view';
  final String? fieldId;
  const FieldAdminPanelView({super.key, required this.fieldId});

  @override
  State<FieldAdminPanelView> createState() => _FieldAdminPanelViewState();
}

class _FieldAdminPanelViewState extends State<FieldAdminPanelView> {
  ProductField? _currentField;
  final TextEditingController _fieldName = TextEditingController();
  final TextEditingController _fieldOrder = TextEditingController();
  Map<String, TextEditingController>? _textEditingControllers;

  @override
  void initState() {
    _currentField = context
        .read<DatabaseBloc>()
        .state
        .productFields
        ?.firstWhere((element) => element.id == widget.fieldId);

    if (_currentField != null) {
      if (_currentField!.isPriceImage && _currentField!.priceImages != null) {
        _textEditingControllers = _createTextEditingControllers();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        !Navigator.of(context).canPop() ? context.go('/ask') : context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                context.go('/ask');
              }
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Admin Panel'),
          actions: [
            if (_currentField != null)
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: BlocBuilder<DatabaseBloc, DatabaseState>(
                  builder: (context, state) {
                    final bool beingLoaded =
                        state.states == DatabaseStates.fieldsBeingLoaded;
                    return Row(
                      children: [
                        Text('Delete'),
                        IconButton(
                          iconSize: 32,
                          onPressed: () async {
                            if (beingLoaded) {
                              Fluttertoast.showToast(msg: 'Please, wait');
                            } else {
                              final delete =
                                  await showOnDatabaseItemDelete(context) ??
                                  false;
                              if (delete && context.mounted) {
                                Fluttertoast.showToast(msg: 'Deleting');
                                context.read<DatabaseBloc>().add(
                                  DatabaseEventDeleteProductField(
                                    productField: _currentField!,
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(msg: 'Phew');
                              }
                            }
                          },
                          icon: beingLoaded
                              ? CircularProgressIndicator()
                              : Icon(
                                  Icons.delete_forever_rounded,
                                  color: context.appColorScheme.errorContainer,
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: _currentField != null
              ? ListView(
                  children: [
                    Column(
                      spacing: 16,
                      crossAxisAlignment: .center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Edit The Field: its id - ${widget.fieldId}',
                          ),
                        ),
                        Container(
                          color: context.appColorScheme.surfaceContainerHigh,
                          child: Column(
                            children: [
                              Divider(thickness: 3),
                              Text(
                                'Field Name. OG name: ${_currentField?.fieldName}',
                              ),
                              TextField(
                                controller: _fieldName,
                                onChanged: (value) => setState(() {}),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: .circular(30),
                                  ),
                                ),
                              ),
                              Text('The name will be ${_fieldName.text}'),
                            ],
                          ),
                        ),
                        Container(
                          color: context.appColorScheme.surfaceContainerHigh,
                          child: Column(
                            children: [
                              Divider(thickness: 3),
                              Text(
                                'Order of the field. OG order: ${_currentField?.order}',
                              ),
                              Text('Must be integer'),
                              TextField(
                                controller: _fieldOrder,
                                onChanged: (value) => setState(() {}),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: .circular(30),
                                  ),
                                ),
                              ),
                              Text('The order will be ${_fieldOrder.text}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_currentField != null)
                      if (_currentField!.isPriceImage &&
                          _currentField!.priceImages != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            color: context.appColorScheme.surfaceContainerHigh,
                            child: Column(
                              children: [
                                Divider(thickness: 3),
                                Text('Modify prices'),
                                _everyPriceFunction(context),
                              ],
                            ),
                          ),
                        ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlocBuilder<DatabaseBloc, DatabaseState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (state.states !=
                                  DatabaseStates.fieldsBeingLoaded) {
                                final order = int.tryParse(
                                  _fieldOrder.text.trim(),
                                );
                                final fieldName = _fieldName.text.trim() != ''
                                    ? _fieldName.text.trim()
                                    : null;
                                Map<String, double>? priceImages;
                                if (_currentField!.isPriceImage) {
                                  priceImages = {};
                                  for (var nominalName
                                      in _textEditingControllers!.keys) {
                                    priceImages[nominalName] =
                                        double.tryParse(
                                          _textEditingControllers![nominalName]
                                                  ?.text ??
                                              '-1',
                                        ) ??
                                        -1;
                                  }
                                }
                                context.read<DatabaseBloc>().add(
                                  DatabaseEventUpdateProductField(
                                    oldField: _currentField!,
                                    order: order,
                                    fieldName: fieldName,
                                    priceImages: priceImages,
                                  ),
                                );
                                Fluttertoast.showToast(
                                  msg: 'Happily ever after',
                                );
                                context.go('/');
                              } else {
                                Fluttertoast.showToast(msg: 'Failed');
                              }
                            },
                            child:
                                state.states != DatabaseStates.fieldsBeingLoaded
                                ? Text('Update The Field')
                                : CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Text('Some error - no field found'),
        ),
      ),
    );
  }

  Map<String, TextEditingController> _createTextEditingControllers() {
    Map<String, TextEditingController> result = {};
    for (var iamgePrice in _currentField!.expectedData!) {
      TextEditingController newController = TextEditingController();
      result[iamgePrice] = newController;
    }
    return result;
  }

  List<Widget> _priceRangeListWidgetGenerator() {
    List<Widget> result = [];
    for (var aPriceImage in _currentField!.expectedData!) {
      result.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(aPriceImage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18, left: 8),
                child: SizedBox(
                  height: 36,
                  width: 125,
                  child: TextField(
                    controller: _textEditingControllers![aPriceImage],
                    onChanged: (value) {
                      _currentField!.priceImages![aPriceImage] =
                          double.tryParse(
                            _textEditingControllers![aPriceImage]!.text,
                          ) ??
                          -1;
                    },
                    keyboardType: .number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    cursorHeight: 24,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      contentPadding: .symmetric(vertical: 2, horizontal: 4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return result;
  }

  Widget _everyPriceFunction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.only(bottom: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(30),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(30),
        ),
        backgroundColor: context.appColorScheme.onPrimaryFixed,
        collapsedBackgroundColor: context.appColorScheme.onPrimaryFixedVariant,

        title: Text(_currentField!.fieldName),
        subtitle: Text('Fill the price options'),
        children: _priceRangeListWidgetGenerator(),
      ),
    );
  }
}
