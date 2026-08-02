import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/widgets/product_card.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MaterialHomePageView extends StatelessWidget {
  final List<Product> userPreferences;
  final List<Product> featuredProducts;
  final Future<void> Function() reFresher;
  final OnOpenProductCardCallBack onOpenProductCardCallBack;
  const MaterialHomePageView({
    super.key,
    required this.userPreferences,
    required this.featuredProducts,
    required this.reFresher,
    required this.onOpenProductCardCallBack,
  });

  @override
  Widget build(BuildContext context) {
    final containerHalfWidth = MediaQuery.sizeOf(context).width / 2 - 28;
    return RefreshIndicator(
      edgeOffset: MediaQuery.paddingOf(context).top + 40,
      onRefresh: reFresher,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              left: 16,
              right: 16,
              top: MediaQuery.paddingOf(context).top + 48 + 16,
              bottom: MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              children: [
                _featuredDealContainer(
                  context: context,
                  containerHalfWidth: containerHalfWidth,
                ),
                Padding(
                  padding: .symmetric(horizontal: 22, vertical: 6),
                  child: Divider(),
                ),
                _favoriteProductsContainer(
                  context: context,
                  containerHalfWidth: containerHalfWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _featuredDealContainer({
    required BuildContext context,
    required double containerHalfWidth,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColorScheme.tertiaryContainer,
        borderRadius: .circular(24),
      ),
      height: 370,
      width: double.maxFinite,
      child: featuredProducts.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 8,
                mainAxisAlignment: .spaceEvenly,
                children: [
                  Column(
                    spacing: 8,
                    crossAxisAlignment: .start,
                    children: [
                      Container(
                        width: containerHalfWidth,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: .circular(16),
                          color: context.appColorScheme.onTertiaryContainer,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Featured\nDeals',
                              textAlign: .center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: .w700,
                                color: context.appColorScheme.tertiaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ProductCardDriver(
                        openProductCardCallBack: openProductCardCallBack,
                        product: featuredProducts[0],
                        additionalSuffix: 'featuredProduct',
                        index: 0,
                        width: containerHalfWidth,
                        height: 278,
                        cornerRadius: 16,
                      ),
                    ],
                  ),
                  if (featuredProducts.length > 1)
                    Column(
                      spacing: 8,
                      crossAxisAlignment: .start,
                      children: [
                        ProductCardDriver(
                          openProductCardCallBack: openProductCardCallBack,
                          product: featuredProducts[1],
                          additionalSuffix: 'featuredProduct',
                          index: 1,
                          width: containerHalfWidth,
                          height: 173,
                          cornerRadius: 16,
                        ),
                        if (featuredProducts.length > 2)
                          ProductCardDriver(
                            openProductCardCallBack: openProductCardCallBack,
                            product: featuredProducts[2],
                            additionalSuffix: 'featuredProduct',
                            index: 2,
                            width: containerHalfWidth,
                            height: 173,
                            cornerRadius: 16,
                          ),
                      ],
                    ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _favoriteProductsContainer({
    required BuildContext context,
    required double containerHalfWidth,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColorScheme.surfaceContainer,
        borderRadius: .circular(24),
      ),
      width: double.maxFinite,
      // height: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            Column(
              mainAxisSize: .min,
              children: [
                ...List.generate(
                  (userPreferences.length + 1) ~/ 2,
                  (index) => Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                    child: ProductCardDriver(
                      product: userPreferences[index * 2],
                      additionalSuffix: 'favorite',
                      openProductCardCallBack: onOpenProductCardCallBack,
                      index: index,
                      height: 256,
                      width: containerHalfWidth,
                      cornerRadius: 16,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: .min,
              children: [
                Container(
                  width: containerHalfWidth,
                  margin: .only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: .circular(16),
                    color: context.appColorScheme.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Favorite',
                        textAlign: .center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: .w700,
                          color: context.appColorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                ...List.generate(
                  userPreferences.length ~/ 2,
                  (index) => Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                    child: ProductCardDriver(
                      product: userPreferences[index * 2 + 1],
                      additionalSuffix: 'favorite',
                      openProductCardCallBack: onOpenProductCardCallBack,
                      index: index,
                      height: 256,
                      width: containerHalfWidth,
                      cornerRadius: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
