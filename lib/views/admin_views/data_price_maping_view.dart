import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DataPriceMapingView extends StatefulWidget {
  const DataPriceMapingView({super.key});

  @override
  State<DataPriceMapingView> createState() => _DataPriceMapingViewState();
}

class _DataPriceMapingViewState extends State<DataPriceMapingView> {
  List<Widget> _fieldsWithOptions = [];
  final List<AppProductField> _mockList = [
    AppProductField(
      id: 'id',
      productId: 'productId',
      order: 0,
      fieldName: 'User Id',
      handler: 'InputField',
      attributes: null,
      expectedData: ['User custom input'],
    ),
    AppProductField(
      id: 'id',
      productId: 'productId',
      order: 0,
      fieldName: 'Region',
      handler: 'DropdownMenu',
      attributes: null,
      expectedData: [
        'North America',
        'South Aerica',
        'Asia',
        'Japan',
        'South Korea',
      ],
    ),
    AppProductField(
      id: 'id',
      productId: 'productId',
      order: 0,
      fieldName: 'Server Id',
      handler: 'InputField',
      attributes: null,
      expectedData: ['User custom input'],
    ),

    AppProductField(
      id: 'id',
      productId: 'productId',
      order: 0,
      fieldName: 'Nominals',
      handler: 'Radio',
      attributes: null,
      expectedData: [
        '12 dimonds',
        '222 dimonds',
        '323 dimonds',
        '61312 dimonds',
      ],
    ),
  ];
  final Map<AppProductField, bool> _priceDimentionFields = {};
  List<Widget> _buildOptions(AppProductField aField) {
    List<Widget> result = [];
    for (var option in aField.expectedData!) {
      result.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          child: Text(option),
        ),
      );
    }
    return result;
  }

  List<Widget> _buildFieldsWithOptions(List<AppProductField> fields) {
    List<Widget> result = [];
    for (var field in fields) {
      result.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Checkbox(
                    fillColor: WidgetStateColor.resolveWith((state) {
                      if (state.contains(WidgetState.selected)) {
                        return context.appColorScheme.primary;
                      } else {
                        return context.appColorScheme.outline;
                      }
                    }),
                    tristate: false,
                    value: _priceDimentionFields[field],
                    onChanged: (value) {
                      setState(() {
                        _priceDimentionFields[field] = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(field.fieldName),
                    ),
                  ),
                  Expanded(child: Column(children: _buildOptions(field))),
                ],
              ),
            ),
            Divider(thickness: 3),
          ],
        ),
      );
    }
    return result;
  }

  @override
  void initState() {
    setState(() {
      for (var value in _mockList) {
        _priceDimentionFields[value] = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _fieldsWithOptions = _buildFieldsWithOptions(_mockList);
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
                  itemCount: _fieldsWithOptions.length,
                  itemBuilder: (context, index) => _fieldsWithOptions[index],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
