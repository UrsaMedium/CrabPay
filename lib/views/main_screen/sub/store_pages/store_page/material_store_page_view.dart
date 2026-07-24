import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/store_page/store_search_bar_driver.dart';
import 'package:crabpay/views/widgets/product_card.dart';
import 'package:flutter/material.dart';

class MaterialStorePageView extends StatelessWidget {
  final List<Product> products;
  final List<Product> filterdProductList;
  final OnOpenProductCardCallBack onOpenProductCardCallBack;
  final Future<void> Function() reFresher;
  final Function(List<Product>) onSearchSubmitedCallBack;
  const MaterialStorePageView({
    super.key,
    required this.reFresher,
    required this.products,
    required this.onOpenProductCardCallBack,
    required this.onSearchSubmitedCallBack,
    required this.filterdProductList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            edgeOffset: MediaQuery.paddingOf(context).top + 40,
            onRefresh: reFresher,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: .only(
                    top: MediaQuery.paddingOf(context).top + 52,
                    bottom: MediaQuery.paddingOf(context).bottom + 8,
                    right: 8,
                    left: 8,
                  ),
                  sliver: SliverCrossAxisGroup(
                    slivers: [
                      SliverPadding(
                        padding: .only(right: 4),
                        sliver: SliverCrossAxisExpanded(
                          flex: 1,
                          sliver: SliverList.builder(
                            itemCount: filterdProductList.isEmpty
                                ? (products.length + 1) ~/ 2
                                : (filterdProductList.length + 1) ~/ 2,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ProductCardDriver(
                                product: filterdProductList.isEmpty
                                    ? products[index * 2]
                                    : filterdProductList[index * 2],
                                additionalSuffix: 'store',
                                openProductCardCallBack:
                                    onOpenProductCardCallBack,
                                index: index,
                                height: 256,
                                width: (MediaQuery.widthOf(context) - 24) / 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: .only(left: 4),
                        sliver: SliverCrossAxisExpanded(
                          flex: 1,
                          sliver: SliverList.builder(
                            itemCount: filterdProductList.isEmpty
                                ? products.length ~/ 2
                                : filterdProductList.length ~/ 2,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(
                                top: index == 0 ? 60 : 8,
                              ),
                              child: ProductCardDriver(
                                product: filterdProductList.isEmpty
                                    ? products[index * 2 + 1]
                                    : filterdProductList[index * 2 + 1],
                                additionalSuffix: 'store',
                                openProductCardCallBack:
                                    onOpenProductCardCallBack,
                                index: index,
                                height: 256,
                                width: (MediaQuery.widthOf(context) - 24) / 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MaterialStoreSearchBarDriver(
            products: products,
            openProductCardCallBack: openProductCardCallBack,
            onSearchSubmitedCallBack: onSearchSubmitedCallBack,
          ),
        ],
      ),
    );
  }
}


// SliverGrid.builder(
//                     itemCount: products.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 6,
//                       crossAxisSpacing: 6,
//                       mainAxisExtent: 270,
//                     ),
//                     itemBuilder: (context, index) => ProductCardDriver(
//                       product: filterdProductList.isEmpty
//                           ? products[index]
//                           : filterdProductList[index],
//                       additionalSuffix: 'store',
//                       openProductCardCallBack: onOpenProductCardCallBack,
//                       index: index,
//                     ),
//                   ),


// ListView.builder(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: .only(
//                 top: MediaQuery.paddingOf(context).top + 48,
//                 bottom: MediaQuery.paddingOf(context).bottom,
//               ),
//               itemExtent: 170,
//               itemCount: filterdProductList.isEmpty
//                   ? products.length
//                   : filterdProductList.length,
//               itemBuilder: (context, index) => ProductCardDriver(
//                 product: filterdProductList.isEmpty
//                     ? products[index]
//                     : filterdProductList[index],
//                 additionalSuffix: 'store',
//                 openProductCardCallBack: onOpenProductCardCallBack,
//                 index: index,
//               ),
//             ),