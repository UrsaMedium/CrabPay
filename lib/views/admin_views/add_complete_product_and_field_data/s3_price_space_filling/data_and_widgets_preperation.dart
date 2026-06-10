import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
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
  Map<ProductField, String>? _priceSpace;
  ProductField? _priceRangeDimension;
  final Map<String, List<String>> _priceDomainDimensions = {};
  final Map<List<String>, double> priceMatrixInput = {};
  final List<Map<String, String>> _domainMatrix = [];
  final List<List<String>> _functionsList = [];
  final Map<List<String>, Map<String, TextEditingController>>
  _textEditingControllers = {};
  final List<Widget> everyPriceFunctionListOfWidgets = [];

  DataAndWidgetsPreperation({required this.context}) {
    _priceSpace = context.read<AdminBloc>().state.priceDimensions;
    //if the price space doesn't exist go back
    if (_priceSpace == null) {
      Fluttertoast.showToast(msg: 'No price space is created');
      context.pop();
    }
    //retreaving range dimension
    for (var field in _priceSpace!.keys) {
      if (_priceSpace![field] == 'range') {
        _priceRangeDimension = field;
      }
    }
    //if there is no range dimension go back
    if (_priceRangeDimension == null) {
      Fluttertoast.showToast(msg: 'How come there is no range');
      context.pop();
    }
    //if the range dimantion is empty go back
    if (_priceRangeDimension!.expectedData == null) {
      Fluttertoast.showToast(
        msg:
            'What? The range field ${_priceRangeDimension!} has no description of the expectedData',
      );
      context.pop();
    }
    //retreaving domain dimensions
    for (var field in _priceSpace!.keys) {
      if (_priceSpace![field] == 'domain') {
        //if a domain dimension is empty go back
        if (field.expectedData == null) {
          Fluttertoast.showToast(
            msg:
                'What? The ${field.fieldName} domain field has no description for the expectadeData',
          );
          context.pop();
        } else {
          _priceDomainDimensions[field.fieldName] = field.expectedData!;
        }
      }
    }
    try {
      _leafWalker();
    } catch (_) {
      rethrow;
    }
    for (var priceFunction in _domainMatrix) {
      _functionsList.add(priceFunction.values.toList());
    }
    if (_textEditingControllers.isNotEmpty) {
      for (var c in _textEditingControllers.values) {
        for (var element in c.values) {
          element.dispose();
        }
      }
      _textEditingControllers.clear();
    }
    _textEditingControllers.addAll(_createTextEditingControllers());
    if (everyPriceFunctionListOfWidgets.isNotEmpty) {
      everyPriceFunctionListOfWidgets.clear();
    }
    everyPriceFunctionListOfWidgets.addAll(_everyPriceFunction(context));
    context.read<AdminBloc>().add(AdminEventSpaceFillingDataIsPrepared());
  }

  void _leafWalker({Map<String, String>? leafNPath}) {
    if (leafNPath == null) {
      leafNPath = {};
      _domainMatrix.clear();
      _leafWalker(leafNPath: leafNPath);
    } else {
      String dimension = _priceDomainDimensions.keys.firstWhere(
        (ofDomains) => !leafNPath!.keys.any((element) => element == ofDomains),
        orElse: () => 'null',
      );
      if (dimension != 'null') {
        for (var value in _priceDomainDimensions[dimension]!) {
          leafNPath[dimension] = value;
          final newPath = Map<String, String>.from(leafNPath);
          _leafWalker(leafNPath: newPath);
        }
      } else {
        _domainMatrix.add(leafNPath);
      }
    }
  }

  Map<List<String>, Map<String, TextEditingController>>
  _createTextEditingControllers() {
    Map<List<String>, Map<String, TextEditingController>> result = {};
    for (var function in _functionsList) {
      Map<String, TextEditingController> newMap = {};
      for (var image in _priceRangeDimension!.expectedData!) {
        TextEditingController newController = TextEditingController();
        newMap[image] = newController;
      }
      result[function] = newMap;
    }
    return result;
  }

  void _inputing(List<String> func, double value) {
    final List<String> newF = List<String>.from(func);
    final double newV = value;
    priceMatrixInput[newF] = newV;
  }

  List<Widget> _priceRangeListWidgetGenerator(List<String> function) {
    List<String> localFunc = List<String>.from(function);
    Map<String, TextEditingController> controllers =
        _textEditingControllers[function]!;
    List<Widget> result = [];
    for (var aPriceImage in _priceRangeDimension!.expectedData!) {
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
                      localFunc.add(aPriceImage);
                      _inputing(localFunc, double.parse(value));
                      localFunc.remove(aPriceImage);
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

  List<Widget> _everyPriceFunction(BuildContext context) {
    List<Widget> result = [];
    for (var function in _functionsList) {
      result.add(
        Padding(
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
            collapsedBackgroundColor:
                context.appColorScheme.onPrimaryFixedVariant,

            title: Text(function.toString()),
            subtitle: Text('Fill the weights for the domain'),
            children: _priceRangeListWidgetGenerator(function),
          ),
        ),
      );
    }

    return result;
  }
}
