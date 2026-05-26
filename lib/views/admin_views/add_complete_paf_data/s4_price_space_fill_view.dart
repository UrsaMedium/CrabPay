import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class PriceSpaceFillView extends StatefulWidget {
  const PriceSpaceFillView({super.key});

  @override
  State<PriceSpaceFillView> createState() => _PriceSpaceFillViewState();
}

class _PriceSpaceFillViewState extends State<PriceSpaceFillView> {
  Map<AppProductField, String>? _priceSpace;
  AppProductField? _priceRangeDimention;
  final Map<String, List<String>> _priceDomainDimentions = {
    'currency': ['rub', 'usd'],
  };
  //for every rangeValue
  Map<String, List<Map<String, String>>> _spaceMatrix = {};
  List<Map<String, String>> _domainMatrix = [];

  @override
  void didChangeDependencies() {
    //getting price space
    _priceSpace = context.read<AdminBloc>().state.priceSpace;
    //if the price space doesn't exist go back
    if (_priceSpace == null) {
      Fluttertoast.showToast(msg: 'No price space is created');
      context.pop();
    }
    //retreaving range dimention
    for (var field in _priceSpace!.keys) {
      if (_priceSpace![field] == 'range') {
        _priceRangeDimention = field;
      }
    }
    //if there is no range dimention go back
    if (_priceRangeDimention == null) {
      Fluttertoast.showToast(msg: 'How come there is no range');
      context.pop();
    }
    //if the range dimantion is empty go back
    if (_priceRangeDimention!.expectedData == null) {
      Fluttertoast.showToast(
        msg:
            'What? The range field ${_priceRangeDimention!} has no description of the expectedData',
      );
      context.pop();
    }
    //retreaving domain dimentions
    for (var field in _priceSpace!.keys) {
      if (_priceSpace![field] == 'domain') {
        //if a domain dimention is empty go back
        if (field.expectedData == null) {
          Fluttertoast.showToast(
            msg:
                'What? The ${field.fieldName} domain field has no description for the expectadeData',
          );
          context.pop();
        } else {
          _priceDomainDimentions[field.fieldName] = field.expectedData!;
        }
      }
    }
    for (var dimention in _priceDomainDimentions.keys) {
      for (var value in _priceDomainDimentions[dimention]!) {
        print('$dimention , $value');
      }
    }
    super.didChangeDependencies();
  }

  void _leafWalker({Map<String, String>? leafNPath}) {
    if (leafNPath == null) {
      leafNPath = {};
      _domainMatrix = [];
    }
    if (leafNPath.keys.any(
      (element) => element == 'bikini bottom21312340979801043',
    )) {
      leafNPath.remove('bikini bottom21312340979801043');
      _domainMatrix.add(leafNPath);
      _leafWalker(leafNPath: leafNPath);
    } else {
      
    }
  }

  List<Widget> _priceRangeListWidgetGenerator() {
    List<Widget> result = [];
    for (var aPriceImage in _priceRangeDimention!.expectedData!) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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

                title: Text('rub'),
                subtitle: Text('Fill the weights for the domain rub'),
                children: _priceRangeListWidgetGenerator(),
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
                      onPressed: () {},
                      child: Text('Next'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('setState'),
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
