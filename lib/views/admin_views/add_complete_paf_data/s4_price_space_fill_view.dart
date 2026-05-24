import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class PriceSpaceFillView extends StatefulWidget {
  const PriceSpaceFillView({super.key});

  @override
  State<PriceSpaceFillView> createState() => _PriceSpaceFillViewState();
}

class _PriceSpaceFillViewState extends State<PriceSpaceFillView> {
  late final Map<AppProductField, String>? _priceSpace;
  final List<String> _currencies = ['rub', 'usd'];
  AppProductField? _priceRange;

  @override
  void didChangeDependencies() {
    _priceSpace = context.read<AdminBloc>().state.priceSpace;
    if (_priceSpace == null) {
      Fluttertoast.showToast(msg: 'No price space is created');
      context.pop();
    }
    _priceSpace!.forEach((key, value) => print('${key.expectedData} = $value'));
    for (var field in _priceSpace!.keys) {
      if (_priceSpace[field] == 'range') {
        _priceRange = field;
      }
    }
    if (_priceRange == null) {
      Fluttertoast.showToast(msg: 'How come there is no range');
      context.pop();
    }
    if (_priceRange!.expectedData == null) {
      Fluttertoast.showToast(
        msg: 'What? There is no return data fo the chosen field',
      );
      context.pop();
    }
    super.didChangeDependencies();
  }

  List<Widget> _priceRangeListWidgetGenerator() {
    List<Widget> result = [];
    for (var aPriceImage in _priceRange!.expectedData!) {
      result.add(Row(children: [Text(aPriceImage)]));
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
            ExpansionTile(title: Text('data')),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
