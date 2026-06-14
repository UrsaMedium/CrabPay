import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/buy_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' as md;

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
                  Expanded(
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Image.network(
                            'http://regred-rainbowbridge.ru/crabpay/images/products/${product.image}',
                            fit: .fitWidth,
                            width: double.infinity,
                            height: 300,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color:
                                      context.appColorScheme.onInverseSurface,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.broken_image,
                                    color:
                                        context.appColorScheme.inversePrimary,
                                    size: 48,
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: context.appColorScheme.inversePrimary,
                                alignment: .center,
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              textAlign: .center,
                              style: TextStyle(
                                color: context.appColorScheme.primaryFixedDim,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Center(
                            child: MarkdownBody(
                              selectable: true,
                              data: product.description,
                              builders: {'latex': LatexElementBuilder()},
                              extensionSet: md.ExtensionSet(
                                [LatexBlockSyntax()],
                                [LatexInlineSyntax()],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColorScheme.primary,
                      foregroundColor: context.appColorScheme.onPrimary,
                    ),
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
                          context.read<DatabaseBloc>().add(
                            DatabaseEventFetchProductFields(
                              productId: productId,
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Ok, I\'am ready to shop'),
                  ),
                ],
              ),
            ),
          );
  }
}
