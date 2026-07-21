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
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: .only(
                top: MediaQuery.paddingOf(context).top + 48,
                bottom: MediaQuery.paddingOf(context).bottom,
              ),
              itemExtent: 170,
              itemCount: filterdProductList.isEmpty
                  ? products.length
                  : filterdProductList.length,
              itemBuilder: (context, index) => ProductCardDriver(
                product: filterdProductList.isEmpty
                    ? products[index]
                    : filterdProductList[index],
                additionalSuffix: 'store',
                openProductCardCallBack: onOpenProductCardCallBack,
                index: index,
              ),
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
