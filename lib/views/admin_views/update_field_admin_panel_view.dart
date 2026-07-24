import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_bloc.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_event.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_state.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/dialogs/on_database_item_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class UpdateFieldAdminPanelView extends StatefulWidget {
  static const routeName = 'update_field_admin_panel_view';
  final String? fieldId;
  final String? productId;
  const UpdateFieldAdminPanelView({
    super.key,
    required this.fieldId,
    required this.productId,
  });

  @override
  State<UpdateFieldAdminPanelView> createState() =>
      _UpdateFieldAdminPanelViewState();
}

class _UpdateFieldAdminPanelViewState extends State<UpdateFieldAdminPanelView> {
  ProductField? _currentField;
  final TextEditingController _fieldName = TextEditingController();
  final TextEditingController _fieldOrder = TextEditingController();

  @override
  void initState() {
    if (widget.fieldId == null || widget.productId == null) {
      Fluttertoast.showToast(msg: 'Failed to pass field data');
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message:
            'UpdateFieldAdminPanelView: initState: failed to pass field data: fieldId: ${widget.fieldId} , productId: ${widget.productId}',
      );
      context.pop();
    }
    _currentField = context
        .read<DatabaseBloc>()
        .state
        .cachedProductFields![widget.productId]
        ?.firstWhere((element) => element.id == widget.fieldId);
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message:
          'UpdateFieldAdminPanelView: initState: _currentField: $_currentField',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        getIt<InnerLoggerHandler>().logBreadcrumb(
          message:
              'UpdateFieldAdminPanelView: onPopInvokedWithResult: didPop: $didPop, result: $result',
        );
        if (didPop) return;
        !Navigator.of(context).canPop() ? context.go('/ask') : context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              getIt<InnerLoggerHandler>().logBreadcrumb(
                message: 'UpdateFieldAdminPanelView: onBackButtonPressed',
              );
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
                child: BlocBuilder<DatabaseBlocAdmin, DatabaseStateAdmin>(
                  builder: (context, state) {
                    final bool beingLoaded =
                        state.states == DatabaseStatesAdmin.dbLoading;
                    return Row(
                      children: [
                        Text('Delete'),
                        IconButton(
                          iconSize: 32,
                          onPressed: () async {
                            getIt<InnerLoggerHandler>().logBreadcrumb(
                              message:
                                  'UpdateFieldAdminPanelView: onDeleteButtonPressed',
                              data: {
                                'currentField': _currentField,
                                'beingLoaded': beingLoaded,
                              },
                            );
                            if (beingLoaded) {
                              Fluttertoast.showToast(msg: 'Please, wait');
                            } else {
                              final delete =
                                  await showOnDatabaseItemDelete(context) ??
                                  false;
                              if (delete && context.mounted) {
                                Fluttertoast.showToast(msg: 'Deleting');
                                context.read<DatabaseBlocAdmin>().add(
                                  DatabaseEventDeleteProductFieldAdmin(
                                    productField: _currentField!,
                                  ),
                                );
                                context.go('/');
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlocBuilder<DatabaseBlocAdmin, DatabaseStateAdmin>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              getIt<InnerLoggerHandler>().logBreadcrumb(
                                message:
                                    'UpdateFieldAdminPanelView: onUpdateButtonPressed',
                                data: {
                                  'currentField': _currentField,
                                  'beingLoaded':
                                      state.states ==
                                      DatabaseStatesAdmin.dbLoading,
                                },
                              );
                              if (state.states !=
                                  DatabaseStatesAdmin.dbLoading) {
                                final order =
                                    int.tryParse(_fieldOrder.text.trim()) ??
                                    _currentField!.order;
                                final fieldName = _fieldName.text.trim() != ''
                                    ? _fieldName.text.trim()
                                    : _currentField!.fieldName;

                                final newField = ProductField(
                                  id: _currentField!.id,
                                  productId: _currentField!.productId,
                                  order: order,
                                  fieldName: fieldName,
                                  handler: _currentField!.handler,
                                  isPriceImage: _currentField!.isPriceImage,
                                  priceImages:
                                      _currentField!.handler == 'InputField' &&
                                          _currentField!.isPriceImage &&
                                          _fieldName.text.trim() != ''
                                      ? {
                                          fieldName: _currentField!
                                              .priceImages!
                                              .values
                                              .first,
                                        }
                                      : _currentField!.priceImages,
                                  expectedData:
                                      _currentField!.handler == 'InputField'
                                      ? [_currentField!.fieldName]
                                      : _currentField!.expectedData,
                                );
                                context.read<DatabaseBlocAdmin>().add(
                                  DatabaseEventUpdateProductFieldAdmin(
                                    field: newField,
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
                            child: state.states != DatabaseStatesAdmin.dbLoading
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
}
