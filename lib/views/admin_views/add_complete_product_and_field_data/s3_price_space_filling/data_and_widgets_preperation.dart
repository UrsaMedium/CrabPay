import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class DataAndWidgetsPreperation {
  final BuildContext context;
  List<ProductField>? productFields;
  ProductField? imageField;
  final Map<String, double> priceImage = {};
  final Map<String, TextEditingController> _textEditingControllers = {};
  Widget? priceImageWidget;

  DataAndWidgetsPreperation({required this.context}) {
    productFields = context.read<AdminBloc>().state.appProductFields;

    if (productFields == null) {
      Fluttertoast.showToast(msg: 'No fields is created');
      context.pop();
    }

    int imageChecker = 0;
    for (var field in productFields!) {
      if (field.isPriceImage) {
        imageField = field;
        imageChecker++;
      }
    }

    if (imageChecker != 1) {
      Fluttertoast.showToast(msg: 'How come there is not just one image field');
      context.pop();
    }

    if (_textEditingControllers.isNotEmpty) {
      for (var c in _textEditingControllers.values) {
        c.dispose();
      }
      _textEditingControllers.clear();
    }

    _textEditingControllers.addAll(_createTextEditingControllers());

    priceImageWidget = _everyPriceFunction(context);
    context.read<AdminBloc>().add(AdminEventPriceFillingDataIsPrepared());
    print('1-----------------------');
  }

  Map<String, TextEditingController> _createTextEditingControllers() {
    Map<String, TextEditingController> result = {};
    for (var iamgePrice in imageField!.expectedData!) {
      TextEditingController newController = TextEditingController();
      result[iamgePrice] = newController;
    }
    return result;
  }

  List<Widget> _priceRangeListWidgetGenerator() {
    Map<String, TextEditingController> controllers = _textEditingControllers;
    List<Widget> result = [];
    for (var aPriceImage in imageField!.expectedData!) {
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
                    controller: controllers[aPriceImage],
                    onChanged: (value) {
                      priceImage[aPriceImage] = double.parse(
                        _textEditingControllers[aPriceImage]!.text,
                      );
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

        title: Text(imageField!.fieldName),
        subtitle: Text('Fill the price options'),
        children: _priceRangeListWidgetGenerator(),
      ),
    );
  }
}
