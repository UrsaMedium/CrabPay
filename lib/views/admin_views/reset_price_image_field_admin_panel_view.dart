import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_bloc.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_event.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_state.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ResetPriceImageFieldAdminPanelView extends StatefulWidget {
  static const routeName = 'reset_price_image_field_admin_panel_view';
  final String? productId;
  const ResetPriceImageFieldAdminPanelView({super.key, this.productId});

  @override
  State<ResetPriceImageFieldAdminPanelView> createState() =>
      _ResetPriceImageFieldAdminPanelViewState();
}

class _ResetPriceImageFieldAdminPanelViewState
    extends State<ResetPriceImageFieldAdminPanelView> {
  late final List<ProductField>? _productFields;
  ProductField? _groupValue;
  late final ProductField? oldImageField;

  @override
  void initState() {
    _productFields = context.read<DatabaseBloc>().state.productFields;
    if (_productFields == null) {
      Fluttertoast.showToast(msg: 'Strange error. No fields detected');
      context.go('/');
    }
    oldImageField = _productFields!
        .where((element) => element.isPriceImage)
        .firstOrNull;
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message:
          'ResetPriceImageFieldAdminPanelView: initState: oldImageField: $oldImageField',
    );
    super.initState();
  }

  void _radioReacts(ProductField field) {
    setState(() {
      _groupValue = field;
    });
  }

  List<Widget> _choices() {
    List<Widget> resultList = [];
    for (final field in _productFields!) {
      resultList.add(
        InkWell(
          onTap: () => _radioReacts(field),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(field.fieldName),
                  leading: Radio<ProductField>(value: field),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return resultList;
  }

  void _execute({
    required BuildContext context,
    required ProductField newImageField,
  }) {
    context.read<DatabaseBlocAdmin>().add(
      DatabaseEventUpdateProductFieldSwapImageFieldAdmin(
        oldImageField: oldImageField,
        newImageField: newImageField,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        getIt<InnerLoggerHandler>().logBreadcrumb(
          message:
              'ResetPriceImageFieldAdminPanelView: onPopInvokedWithResult: didPop: $didPop, result: $result',
        );
        if (didPop) return;
        !Navigator.of(context).canPop() ? context.go('/ask') : context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              getIt<InnerLoggerHandler>().logBreadcrumb(
                message:
                    'ResetPriceImageFieldAdminPanelView: onBackButtonPressed',
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
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: RadioGroup<ProductField>(
                groupValue: _groupValue,
                onChanged: (value) {
                  if (value != null) {
                    _radioReacts(value);
                  }
                },
                child: Column(children: _choices()),
              ),
            ),
            BlocListener<DatabaseBlocAdmin, DatabaseStateAdmin>(
              listener: (context, state) {
                getIt<InnerLoggerHandler>().logBreadcrumb(
                  message:
                      'ResetPriceImageFieldAdminPanelView: BlocListener: DatabaseState changed',
                  data: {'state': state.states.toString()},
                );
                if (state.states == DatabaseStatesAdmin.dbLoading) {
                  // GlobalLoadingScreen().show();
                } else {
                  // GlobalLoadingScreen().hide();
                  context.go('/');
                }
              },
              child: ElevatedButton(
                onPressed: _groupValue == null
                    ? null
                    : () {
                        getIt<InnerLoggerHandler>().logBreadcrumb(
                          message:
                              'ResetPriceImageFieldAdminPanelView: onPressed',
                          data: {'newImageField': _groupValue},
                        );
                        _execute(context: context, newImageField: _groupValue!);
                      },
                child: Text('Set new price image'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
