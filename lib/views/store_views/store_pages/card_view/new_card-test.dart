import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/buy_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CardView extends StatelessWidget {
  static const routeName = 'card-view';
  final String productId;
  const CardView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    List<ProductField>? productFields;
    List<PriceFunction>? priceFunction;
    Product? product = context.read<DatabaseBloc>().state.products?.firstWhere(
      (product) => product.id == productId,
    );
    context.read<DatabaseBloc>().add(
      DatabaseEventFetchProductFields(productId: productId),
    );
    context.read<DatabaseBloc>().add(
      DatabaseEventFetchPriceFunctions(productId: productId),
    );
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
                  import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyBottomSheet extends StatefulWidget {
  final String productId;
  final List<ProductField> productFields;
  const BuyBottomSheet({
    super.key,
    required this.productId,
    required this.productFields,
  });

  @override
  State<BuyBottomSheet> createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {
  Map<String, String> retrievedData = {};

  void _onBottomSheetDataRetrieved(String fieldName, String dataReceived) {
    setState(() {
      retrievedData[fieldName] = dataReceived;
    });
  }

  List<Widget> _propertySlivers(List<ProductField> properties) {
    properties.sort((a, b) => a.order.compareTo(b.order));
    List<Widget> result = [];
    for (var each in properties) {
      result.add(
        SliverToBoxAdapter(
          child: theAppWidgetBuilder(
            collectedDataBridge: _onBottomSheetDataRetrieved,
            context: context,
            fieldName: each.fieldName,
            handler: each.handler,
            attributes: each.attributes,
            expectedData: each.expectedData,
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<ProductField> properties = context
        .read<DatabaseBloc>()
        .state
        .productFields!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: _propertySlivers(properties),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 32,
              top: 12,
            ),
            child: ElevatedButton(
              onPressed: () {
                print(retrievedData);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColorScheme.primary,
                foregroundColor: context.appColorScheme.onPrimary,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Add To Cart',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
                  Image.network(product.image),
                  Text(product.name),
                  Expanded(child: Container()),
                  ElevatedButton(
                    onPressed: () async {
                      productFields = context
                          .read<DatabaseBloc>()
                          .state
                          .productFields;
                      priceFunction = context
                          .read<DatabaseBloc>()
                          .state
                          .priceFunctions;

                      if (productFields != null && priceFunction != null) {
                        showModalBottomSheet(
                          showDragHandle: true,
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Wrap(
                              children: [
                                BuyBottomSheet(
                                  productId: product.id,
                                  productFields: productFields!,
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                       
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
