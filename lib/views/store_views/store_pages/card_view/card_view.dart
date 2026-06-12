import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/buy_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class CardView extends StatelessWidget {
  static const routeName = 'card-view';
  final String productId;
  const CardView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    List<ProductField>? productFields;
    Product? product = context.read<DatabaseBloc>().state.products?.firstWhere(
      (product) => product.id == productId,
    );
    context.read<DatabaseBloc>().add(
      DatabaseEventFetchProductFields(productId: productId),
    );
    Currencies currency = context
        .read<DatabaseBloc>()
        .state
        .currencies!
        .firstWhere((curr) => curr.name == product?.currencies);
    return product == null
        ? Scaffold(
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
            body: Center(child: Text('Something went wrong')),
          )
        : Hero(
            tag: 'card-hero-${product.id}',
            child: Scaffold(
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
              body: Column(
                children: [
                  Image.network(
                    'http://regred-rainbowbridge.ru/crabpay/images/products/${product.image}',
                  ),
                  Text(product.name),
                  Expanded(child: Container()),
                  ElevatedButton(
                    onPressed: () async {
                      productFields = context
                          .read<DatabaseBloc>()
                          .state
                          .productFields;
                      if (productFields != null) {
                        showModalBottomSheet(
                          showDragHandle: true,
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Wrap(
                              children: [
                                BuyBottomSheet(
                                  currency: currency,
                                  productId: product.id,
                                  productFields: productFields!,
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        productFields = context
                            .read<DatabaseBloc>()
                            .state
                            .productFields;
                        if (productFields == null) {
                          Fluttertoast.showToast(
                            msg: 'No Fields! Something went wrong.',
                          );
                        }
                      }
                    },
                    child: Text("Buy"),
                  ),
                ],
              ),
            ),
          );
  }
}
