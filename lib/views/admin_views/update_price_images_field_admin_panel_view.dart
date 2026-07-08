import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/dialogs/on_database_item_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class UpdatePriceImagesFieldAdminPanelView extends StatefulWidget {
  static const routeName = 'update_price_images_field_admin_panel_view';
  final String? fieldId;
  const UpdatePriceImagesFieldAdminPanelView({
    super.key,
    required this.fieldId,
  });

  @override
  State<UpdatePriceImagesFieldAdminPanelView> createState() =>
      _UpdatePriceImagesFieldAdminPanelViewState();
}

class _UpdatePriceImagesFieldAdminPanelViewState
    extends State<UpdatePriceImagesFieldAdminPanelView> {
  ProductField? _currentField;
  Map<String, TextEditingController>? _textEditingControllers;

  @override
  void initState() {
    _currentField = context
        .read<DatabaseBloc>()
        .state
        .productFields
        ?.firstWhere((element) => element.id == widget.fieldId);

    if (_currentField != null) {
      if (_currentField!.isPriceImage) {
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
                context.go('/');
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
                        state.states == DatabaseStates.dbLoading;
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
                    if (_currentField != null)
                      if (_currentField!.isPriceImage)
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
                              if (state.states != DatabaseStates.dbLoading) {
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
                                final newImageField = ProductField(
                                  id: _currentField!.id,
                                  productId: _currentField!.productId,
                                  order: _currentField!.order,
                                  fieldName: _currentField!.fieldName,
                                  handler: _currentField!.handler,
                                  isPriceImage: true,
                                  priceImages: priceImages,
                                  expectedData:
                                      _currentField!.handler == 'InputField'
                                      ? [_currentField!.fieldName]
                                      : _currentField!.expectedData,
                                );
                                context.read<DatabaseBloc>().add(
                                  DatabaseEventUpdateProductField(
                                    field: newImageField,
                                  ),
                                );
                                Fluttertoast.showToast(
                                  msg: 'Happily ever after',
                                );
                                context.go('/');
                              } else {
                                Fluttertoast.showToast(msg: 'Wait');
                              }
                            },
                            child: state.states != DatabaseStates.dbLoading
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
    _currentField!.priceImages = {};
    for (var aPriceImage in _currentField!.expectedData!) {
      _currentField!.priceImages![aPriceImage] = -1;
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
                      _currentField!.priceImages?[aPriceImage] =
                          double.tryParse(
                            _textEditingControllers![aPriceImage]?.text ?? '-1',
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
