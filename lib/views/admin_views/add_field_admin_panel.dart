import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s2_add_fields_views/field_constructor_bottom_sheet.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s2_add_fields_views/s2_add_product_fields_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AddFieldAdminPanelView extends StatefulWidget {
  static const routeName = 'add_field_admin_panel_view';
  final String? productId;
  const AddFieldAdminPanelView({super.key, required this.productId});

  @override
  State<AddFieldAdminPanelView> createState() => _AddFieldAdminPanelViewState();
}

class _AddFieldAdminPanelViewState extends State<AddFieldAdminPanelView> {
  final Map<ProductField, Widget> _fieldWidgetsMap = {};
  final List<String> _fieldNames = [];

  @override
  void initState() {
    final originalFieldsList = context.read<DatabaseBloc>().state.productFields;
    if (originalFieldsList != null) {
      for (var field in originalFieldsList) {
        _fieldNames.add(field.fieldName);
      }
    }
    super.initState();
  }

  void _deleteField(ProductField fieldToDelte) {
    setState(() {
      _fieldNames.remove(fieldToDelte.fieldName);
      _fieldWidgetsMap.remove(fieldToDelte);
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
            productId: widget.productId!,
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
    if (imageChecker != 0 || result.isEmpty) return null;
    return result;
  }

  void _updateFieldsList(ProductField field) {
    if (!_fieldWidgetsMap.keys.any(
      (element) => element.fieldName == field.fieldName,
    )) {
      setState(() {
        _fieldNames.add(field.fieldName);
        _fieldWidgetsMap[field] = AField(
          dontUseRadio: true,
          fieldIsImage: (p1) {},
          field: field,
          dataBridge: (p0, p1) {},
          deleteMe: _deleteField,
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: 'ERROR A field with the same name already exists',
      );
    }
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
        ),
        body: widget.productId != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.8,
                              ),
                              child: CustomScrollView(
                                shrinkWrap: true,
                                slivers: [
                                  SliverList.builder(
                                    itemCount: _fieldWidgetsMap.length,
                                    itemBuilder: (context, index) {
                                      return _fieldWidgetsMap.values
                                          .toList()[index];
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
                                                    alreadyExistingFields:
                                                        _fieldNames,
                                                    onNewFieldAdding:
                                                        _updateFieldsList,
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: context
                                                  .appColorScheme
                                                  .onPrimary,
                                              foregroundColor: context
                                                  .appColorScheme
                                                  .primary,
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
                                  child: BlocBuilder<DatabaseBloc, DatabaseState>(
                                    builder: (context, state) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          final collectFields =
                                              _collectFields();
                                          if (collectFields != null) {
                                            Fluttertoast.showToast(msg: 'Boop');
                                            try {
                                              for (var field in collectFields) {
                                                final fieldToPush =
                                                    ProductField(
                                                      id: '',
                                                      productId:
                                                          widget.productId!,
                                                      order: field.order,
                                                      fieldName:
                                                          field.fieldName,
                                                      isPriceImage:
                                                          field.isPriceImage,
                                                      handler: field.handler,
                                                      priceImages:
                                                          field.priceImages,
                                                      expectedData:
                                                          field.expectedData,
                                                    );
                                                context.read<DatabaseBloc>().add(
                                                  DatabaseEventAddProductField(
                                                    productField: fieldToPush,
                                                  ),
                                                );
                                              }
                                              context.go('/');
                                            } catch (e) {
                                              Fluttertoast.showToast(
                                                msg: 'BOO',
                                              );
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                              msg:
                                                  'Something wrong with the fields',
                                            );
                                          }
                                        },
                                        child:
                                            state.states !=
                                                DatabaseStates.fieldsBeingLoaded
                                            ? Text('Push The Fields')
                                            : CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Text('Something went wron. No product id :()'),
      ),
    );
  }
}
