import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
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

  Future<void> dataPrefetching(BuildContext context) async {
    context.read<DatabaseBloc>().add(
      DatabaseEventFetchProductFields(productId: productId),
    );
    final currentUser =
        context.read<AuthBloc>().state.currentUser ?? appTempUser;
    context.read<CartBloc>().add(
      CartEventFetchCartItems(userId: currentUser.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ProductField>? productFields;
    Product? product = context.read<DatabaseBloc>().state.products?.firstWhere(
      (product) => product.id == productId,
    );
    Currencies currency = context
        .read<DatabaseBloc>()
        .state
        .currencies!
        .firstWhere((curr) => curr.name == product?.currencies);
    dataPrefetching(context);
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
        : PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }
              !Navigator.of(context).canPop() ? context.go('/') : context.pop();
            },
            child: Hero(
              tag: 'card-hero-${product.id}',
              createRectTween: (begin, end) =>
                  MaterialRectArcTween(begin: begin, end: end),
              child: ClipRRect(
                borderRadius: .zero,
                clipBehavior: .antiAlias,
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
                                'http://regred-rainbowbridge.ru/crabpay/images/products/${product.image}.png',
                                fit: .fitWidth,
                                width: double.infinity,
                                height: 300,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: context
                                          .appColorScheme
                                          .onInverseSurface,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.broken_image,
                                        color: context
                                            .appColorScheme
                                            .inversePrimary,
                                        size: 48,
                                      ),
                                    ),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: context
                                            .appColorScheme
                                            .inversePrimary,
                                        alignment: .center,
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
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
                                    color:
                                        context.appColorScheme.primaryFixedDim,
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
                      BlocBuilder<DatabaseBloc, DatabaseState>(
                        buildWhen: (previous, current) =>
                            current.states ==
                                DatabaseStates.productFieldsFetched ||
                            current.states !=
                                DatabaseStates.productFieldsNotFetched,
                        builder: (context, state) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.appColorScheme.primary,
                              foregroundColor: context.appColorScheme.onPrimary,
                            ),
                            onPressed: () async {
                              productFields = state.productFields;
                              if (productFields != null) {
                                await showModalBottomSheet(
                                  showDragHandle: false,
                                  useSafeArea: false,
                                  context: context,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  backgroundColor: context
                                      .appColorScheme
                                      .surfaceContainerLow
                                      .withValues(alpha: .6),

                                  // barrierColor: context.appColorScheme.outline,
                                  builder: (BuildContext context) {
                                    return Wrap(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: .only(
                                              topLeft: Radius.circular(40),
                                              topRight: Radius.circular(40),
                                            ),
                                            border: .all(
                                              color: context
                                                  .appColorScheme
                                                  .surfaceContainerLow
                                                  .withValues(alpha: .5),
                                            ),
                                          ),
                                          child: BuyBottomSheet(
                                            currency: currency,
                                            productId: product.id,
                                            productFields: productFields!,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                // if (context.mounted) {
                                //   final currentUser =
                                //       context
                                //           .read<AuthBloc>()
                                //           .state
                                //           .currentUser ??
                                //       appTempUser;
                                //   context.read<CartBloc>().add(
                                //     CartEventFetchCartItems(
                                //       userId: currentUser.id,
                                //     ),
                                //   );
                                // }
                              } else {
                                productFields = state.productFields;
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
                            child:
                                state.states ==
                                    DatabaseStates.productFieldsFetched
                                ? Text('Ok, I\'am ready to shop')
                                : state.states ==
                                      DatabaseStates.productFieldsNotFetched
                                ? Text('No fields. Tap to try again')
                                : CircularProgressIndicator(
                                    color: context.appColorScheme.onPrimary,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
