import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DataPriceMapingView extends StatefulWidget {
  const DataPriceMapingView({super.key});

  @override
  State<DataPriceMapingView> createState() => _DataPriceMapingViewState();
}

class _DataPriceMapingViewState extends State<DataPriceMapingView> {

  List<Widget> peepala(AppProductField oo) {
    List<Widget> result = [];
    for (var item in oo.expectedData!) {
      result.add(
        Padding(padding: const EdgeInsets.all(8.0), child: Text(item)),
      );
    }
    return result;
  }

  void babala() {
    bool value = false;
    for (var item in _fields) {
      _listOfFieldsWithExpectedData.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Checkbox(
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        _checked[item.fieldName] = value!;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.fieldName),
                  ),
                  Column(children: peepala(item)),
                ],
              ),
            ),
            Divider(thickness: 2),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    boobala();
    babala();
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
          mainAxisAlignment: .center,
          children: [
            CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverList.builder(
                  itemCount: _fields.length,
                  itemBuilder: (context, index) =>
                      _listOfFieldsWithExpectedData[index],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
