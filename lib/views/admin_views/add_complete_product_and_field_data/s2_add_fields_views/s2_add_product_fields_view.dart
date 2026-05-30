import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
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

  final List<ProductField> _fieldsList = [];
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
    if (!_fieldsList.any((element) => element.fieldName == field.fieldName)) {
      setState(() {
        _fieldsList.add(field);
        _fieldNames.add(field.fieldName);
        _fieldWidgetsMap[field] = AField(
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

  void _deleteField(ProductField fieldToDelte) {
    setState(() {
      _fieldsList.remove(fieldToDelte);
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
    List<ProductField> result = [];
    for (int i = 0; i < _fieldsList.length; i++) {
      if (_fieldsList[i].fieldName != '' && _fieldsList[i].handler != '') {
        result.add(
          ProductField(
            id: '$i',
            productId: _appProduct!.name,
            order: i * 10,
            fieldName: _fieldsList[i].fieldName,
            handler: _fieldsList[i].handler,
            attributes: _fieldsList[i].attributes,
            expectedData: _fieldsList[i].expectedData,
          ),
        );
      } else {
        return null;
      }
    }
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
                      itemCount: _fieldsList.length,
                      itemBuilder: (context, index) {
                        return _fieldWidgetsMap[_fieldsList[index]];
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
                          context.read<AdminBloc>().add(
                            AdminEventSubmitsFields(
                              appProductFields: collectFields,
                            ),
                          );
                          context.go(
                            '/add_complete_product_product_view/add_product_fields_view/price_dimensions_maping_view',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        List<ProductField>? collectFields = [
                          ProductField(
                            id: 'id1',
                            productId: 'Mock product',
                            order: 10,
                            fieldName: 'Mock field 1',
                            handler: 'InputField',
                            expectedData: ['User Custom Input'],
                          ),
                          ProductField(
                            id: 'id2',
                            productId: 'Mock product',
                            order: 20,
                            fieldName: 'Mock field 2',
                            handler: 'DropdownList',
                            expectedData: ['drop1', 'drop2', 'drop3'],
                          ),
                          ProductField(
                            id: 'id3',
                            productId: 'Mock product',
                            order: 30,
                            fieldName: 'Mock field 3',
                            handler: 'RadioList',
                            expectedData: ['radio1', 'radio2', 'radio3'],
                          ),
                        ];
                        context.read<AdminBloc>().add(
                          AdminEventSubmitsFields(
                            appProductFields: collectFields,
                          ),
                        );
                        context.go(
                          '/add_complete_product_product_view/add_product_fields_view/price_space_maping_view',
                        );
                      },
                      child: Text('Mock Data'),
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

class AField extends StatelessWidget {
  final Function(String, String) dataBridge;
  final Function(ProductField) deleteMe;
  final ProductField field;
  const AField({
    super.key,
    required this.field,
    required this.dataBridge,
    required this.deleteMe,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // key: ValueKey(field.fieldName),
      children: [
        theAppWidgetBuilder(
          collectedDataBridge: dataBridge,
          context: context,
          fieldName: field.fieldName,
          handler: field.handler,
          attributes: null,
          expectedData: field.expectedData,
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            alignment: .topRight,
            child: IconButton(
              onPressed: () => deleteMe(field),
              icon: Icon(Icons.delete),
            ),
          ),
        ),
      ],
    );
  }
}
