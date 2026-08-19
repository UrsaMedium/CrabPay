import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/driver/store_page_cubit.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/store_page_search/driver/store_search_bar_driver.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialStorePageView extends StatelessWidget {
  final OnOpenProductCardCallBack onOpenProductCardCallBack;
  final Future<void> Function() reFresher;
  final Function(List<Product>) onSearchSubmitedCallBack;
  const MaterialStorePageView({
    super.key,
    required this.reFresher,
    required this.onOpenProductCardCallBack,
    required this.onSearchSubmitedCallBack,
    // required this.filterdProductList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            edgeOffset: MediaQuery.paddingOf(context).top,
            onRefresh: reFresher,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: .only(
                    top: MediaQuery.paddingOf(context).top + 8,
                    bottom: MediaQuery.paddingOf(context).bottom + 16,
                    right: 8,
                    left: 8,
                  ),
                  sliver: Builder(
                    builder: (context) {
                      final products = context
                          .select<StorePageCubit, List<Product>>(
                            (cubit) => cubit.state.productsToShow ?? [],
                          );
                      return SliverCrossAxisGroup(
                        slivers: [
                          SliverPadding(
                            padding: .only(right: 4),
                            sliver: SliverList.builder(
                              itemCount: (products.length + 1) ~/ 2,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: ProductCardDriver(
                                  product: products[index * 2],
                                  additionalSuffix: 'store',
                                  openProductCardCallBack:
                                      onOpenProductCardCallBack,
                                  index: index,
                                  height: 256,
                                  width: (MediaQuery.widthOf(context) - 24) / 2,
                                  cornerRadius: 16,
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: .only(left: 4),
                            sliver: SliverList.builder(
                              itemCount: products.length ~/ 2,
                              itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(
                                  top: index == 0 ? 60 : 8,
                                ),
                                child: ProductCardDriver(
                                  product: products[index * 2 + 1],
                                  additionalSuffix: 'store',
                                  openProductCardCallBack:
                                      onOpenProductCardCallBack,
                                  index: index,
                                  height: 256,
                                  width: (MediaQuery.widthOf(context) - 24) / 2,
                                  cornerRadius: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              final products = context.select<StorePageCubit, List<Product>>(
                (cubit) => cubit.state.products ?? [],
              );
              return MaterialStoreSearchBarDriver(
                products: products,
                openProductCardCallBack: openProductCardCallBack,
                onSearchSubmitedCallBack: (prdcts) =>
                    onSearchSubmitedCallBack(prdcts),
              );
            },
          ),
        ],
      ),
    );
  }
}
