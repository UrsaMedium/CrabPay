import 'package:crabpay/core/backend/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/global_loading_screen.dart';
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

  @override
  void initState() {
    _productFields = context.read<DatabaseBloc>().state.productFields;
    if (_productFields == null) {
      Fluttertoast.showToast(msg: 'Strange error. No fields detected');
      context.go('/');
    }
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
            BlocListener<DatabaseBloc, DatabaseState>(
              listener: (context, state) {
                if (state.states != DatabaseStates.fieldsBeingLoaded) {
                  GlobalLoadingScreen().show();
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  try {
                    Fluttertoast.showToast(
                      msg: _groupValue?.fieldName ?? 'Choose a field',
                    );
                    if (_groupValue != null) {
                      if (_groupValue!.expectedData != null) {
                        final haveImageField = _productFields!.any(
                          (field) => field.isPriceImage,
                        );
                        if (haveImageField) {
                          final imageField = _productFields.firstWhere(
                            (field) => field.isPriceImage,
                          );
                          if (imageField.id != _groupValue!.id) {
                            Fluttertoast.showToast(msg: 'LESGOOOOO');
                            context.read<DatabaseBloc>().add(
                              DatabaseEventUpdateProductField(
                                oldField: imageField,
                                isPriceImage: false,
                              ),
                            );
                            Map<String, double> newPriceImages = {};
                            for (var dataToBeExpected
                                in _groupValue!.expectedData!) {
                              newPriceImages[dataToBeExpected] = -1;
                            }
                            context.read<DatabaseBloc>().add(
                              DatabaseEventUpdateProductField(
                                oldField: _groupValue!,
                                isPriceImage: true,
                                priceImages: newPriceImages,
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Huh, You Funny. GET OUT',
                            );
                          }
                        } else {
                          Fluttertoast.showToast(msg: 'LESGO');
                          Map<String, double> newPriceImages = {};
                          for (var dataToBeExpected
                              in _groupValue!.expectedData!) {
                            newPriceImages[dataToBeExpected] = -1;
                          }
                          context.read<DatabaseBloc>().add(
                            DatabaseEventUpdateProductField(
                              oldField: _groupValue!,
                              isPriceImage: true,
                              priceImages: newPriceImages,
                            ),
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: 'This field has nothing to return',
                        );
                      }
                    }
                  } catch (e) {
                    print('Error: ${e.toString()}');
                    Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
                    GlobalLoadingScreen().hide();
                  }
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
