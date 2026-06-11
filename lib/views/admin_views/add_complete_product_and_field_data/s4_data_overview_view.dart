import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DataOverviewView extends StatelessWidget {
  const DataOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final Product? appProduct = context.read<AdminBloc>().state.appProduct;
    final List<ProductField>? appProductFields = context
        .read<AdminBloc>()
        .state
        .appProductFields;
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
      body:
          !(appProductFields != null &&
              appProduct != null)
          ? Text('no data')
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _productOverview(context, appProduct),
                    _fieldsOverview(context, appProductFields),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 32.0,
                        right: 32.0,
                        top: 8,
                        bottom: 32,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.appColorScheme.primary,
                          foregroundColor: context.appColorScheme.onPrimary,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          context.read<AdminBloc>().add(
                            AdminEventPushesData(context: context),
                          );
                        },
                        child: Text('Send Data'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

Widget _fieldsOverview(
  BuildContext context,
  List<ProductField> appProductFields,
) {
  List<Widget> fields = [];
  for (var field in appProductFields) {
    fields.add(
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(30),
        ),
        color: context.appColorScheme.onPrimaryFixedVariant,
        child: Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 16, top: 8, right: 6),
          child: Column(
            children: [
              Card(
                elevation: 7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 2,
                  ),
                  child: Text('Field Name: ${field.fieldName}'),
                ),
              ),
              Column(
                spacing: 8,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text('Handler'),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text(field.handler),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text('Attributes'),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text("${field.priceImages}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text('Expected Data'),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text("${field.expectedData}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text('Order'),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text("${field.order}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(30),
      ),
      color: context.appColorScheme.onPrimaryFixed,
      child: Padding(
        padding: const EdgeInsets.only(left: 6, bottom: 16, top: 8, right: 6),
        child: Column(
          children: [
            Card(
              elevation: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 2,
                ),
                child: Text('Product Data'),
              ),
            ),
            ...fields,
          ],
        ),
      ),
    ),
  );
}

Widget _productOverview(BuildContext context, Product appProduct) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(30),
      ),
      color: context.appColorScheme.onPrimaryFixedVariant,
      child: Padding(
        padding: const EdgeInsets.only(left: 6, bottom: 16, top: 8, right: 6),
        child: Column(
          children: [
            Card(
              elevation: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 2,
                ),
                child: Text('Product Data'),
              ),
            ),
            Column(
              spacing: 8,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text('Name'),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Text(appProduct.name),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text('Image Url'),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Text(appProduct.image),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text('Description'),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Text(appProduct.description),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
