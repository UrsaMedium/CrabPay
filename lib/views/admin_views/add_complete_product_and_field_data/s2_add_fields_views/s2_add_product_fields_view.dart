import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_event.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s2_add_fields_views/field_constructor_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AddProductFieldsView extends StatefulWidget {
  const AddProductFieldsView({super.key});
  @override
  State<AddProductFieldsView> createState() => _AddProductFieldsViewState();
}

class _AddProductFieldsViewState extends State<AddProductFieldsView> {
  Product? _appProduct;

  final Map<ProductField, Widget> _fieldWidgetsMap = {};
  final Map<String, String> _dataFromFieldsToTest = {};
  final List<String> _fieldNames = [];

  @override
  void initState() {
    _appProduct = context.read<AdminBloc>().state.appProduct;
    if (_appProduct == null) {
      Fluttertoast.showToast(msg: 'ERROR no AppProduct');
      context.pop();
    }
    super.initState();
  }

  void _updateFieldsList(ProductField field) {
    if (!_fieldWidgetsMap.keys.any(
      (element) => element.fieldName == field.fieldName,
    )) {
      setState(() {
        _fieldNames.add(field.fieldName);
        _fieldWidgetsMap[field] = AField(
          fieldIsImage: _theImageIsChosen,
          field: field,
          dataBridge: _dataBridgeToTest,
          deleteMe: _deleteField,
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: 'ERROR A field with the same name already exists',
      );
    }
  }

  void _theImageIsChosen(ProductField chosenImage) {
    for (var field in _fieldWidgetsMap.keys) {
      field.makeThemImage = chosenImage.fieldName == field.fieldName;
      _fieldWidgetsMap[field] = AField(
        fieldIsImage: _theImageIsChosen,
        field: field,
        dataBridge: _dataBridgeToTest,
        deleteMe: _deleteField,
      );
    }
    setState(() {});
  }

  void _deleteField(ProductField fieldToDelte) {
    setState(() {
      _fieldNames.remove(fieldToDelte.fieldName);
      _fieldWidgetsMap.remove(fieldToDelte);
    });
  }

  void _dataBridgeToTest(String caller, String passedData) {
    setState(() {
      _dataFromFieldsToTest[caller] = passedData;
    });
  }

  List<ProductField>? _collectFields() {
    int imageChecker = 0;
    List<ProductField> result = [];
    for (int i = 0; i < _fieldWidgetsMap.length; i++) {
      if (_fieldWidgetsMap.keys.toList()[i].fieldName != '' &&
          _fieldWidgetsMap.keys.toList()[i].handler != '') {
        result.add(
          ProductField(
            id: '$i',
            productId: _appProduct!.id,
            order: i * 10,
            fieldName: _fieldWidgetsMap.keys.toList()[i].fieldName,
            handler: _fieldWidgetsMap.keys.toList()[i].handler,
            priceImages: _fieldWidgetsMap.keys.toList()[i].priceImages,
            expectedData: _fieldWidgetsMap.keys.toList()[i].expectedData,
            isPriceImage: _fieldWidgetsMap.keys.toList()[i].isPriceImage,
          ),
        );
        if (_fieldWidgetsMap.keys.toList()[i].isPriceImage) imageChecker++;
      } else {
        return null;
      }
    }
    if (imageChecker != 1) return null;
    return result;
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverList.builder(
                      itemCount: _fieldWidgetsMap.length,
                      itemBuilder: (context, index) {
                        return _fieldWidgetsMap.values.toList()[index];
                      },
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 32,
                          right: 32,
                          bottom: 32,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                showModalBottomSheet(
                                  context: context,
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return AddFieldBottomSheet(
                                      alreadyExistingFields: _fieldNames,
                                      onNewFieldAdding: _updateFieldsList,
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.appColorScheme.onPrimary,
                                foregroundColor: context.appColorScheme.primary,
                                // minimumSize: Size(double.infinity, 50),
                              ),
                              label: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
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
                        List<ProductField>? collectFields = _collectFields();
                        if (collectFields != null) {
                          print('s2-----------------------');
                          context.read<AdminBloc>().add(
                            AdminEventSubmitsFields(
                              appProductFields: collectFields,
                            ),
                          );
                          context.go(
                            '/add_complete_product_product_view/add_product_fields_view/price_space_fill_view',
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Every field must has a name and a handler',
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

class AField extends StatefulWidget {
  final Function(ProductField) fieldIsImage;
  final Function(String, String) dataBridge;
  final Function(ProductField) deleteMe;
  final ProductField field;
  const AField({
    super.key,
    required this.field,
    required this.dataBridge,
    required this.deleteMe,
    required this.fieldIsImage,
  });

  @override
  State<AField> createState() => _AFieldState();
}

class _AFieldState extends State<AField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => widget.fieldIsImage(widget.field),
          child: Icon(
            widget.field.isPriceImage
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
          ),
        ),
        Expanded(
          child: Stack(
            // key: ValueKey(field.fieldName),
            children: [
              theAppWidgetBuilder(
                collectedDataBridge: widget.dataBridge,
                context: context,
                fieldName: widget.field.fieldName,
                handler: widget.field.handler,
                priceImages: null,
                expectedData: widget.field.expectedData,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  alignment: .topRight,
                  child: IconButton(
                    onPressed: () => widget.deleteMe(widget.field),
                    icon: Icon(Icons.delete),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
