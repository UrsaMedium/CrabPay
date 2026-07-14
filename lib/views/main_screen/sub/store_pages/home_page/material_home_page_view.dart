import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
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
    return RefreshIndicator(
      edgeOffset: MediaQuery.paddingOf(context).top,
      onRefresh: reFresher,
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            SliverPadding(
              padding: EdgeInsetsGeometry.only(
                top: MediaQuery.paddingOf(context).top,
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                alignment: .centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 8, bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: context.appColorScheme.outline),
                    ),
                    child: Text(
                      'Featured',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: .w700,
                        color: context.appColorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            featuredProducts.isNotEmpty
                ? SliverList.builder(
                    itemCount: featuredProducts.length,
                    itemBuilder: (context, index) => ProductCardDriver(
                      product: featuredProducts[index],
                      additionalSuffix: 'featuredProduct',
                      openProductCardCallBack: onOpenProductCardCallBack,
                      index: index,
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Text('Today there is no featured product'),
                  ),
            userPreferences.isNotEmpty
                ? SliverToBoxAdapter(
                    child: Align(
                      alignment: .centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 8,
                          bottom: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: context.appColorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: context.appColorScheme.outline,
                            ),
                          ),
                          child: Text(
                            'Favorite',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: .w700,
                              color: context.appColorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: context.appColorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: context.appColorScheme.outline,
                            ),
                          ),
                          child: Text(
                            'You Favore Nothing :(',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: .w700,
                              color: context.appColorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            userPreferences.isNotEmpty
                ? SliverList.builder(
                    itemCount: userPreferences.length,
                    itemBuilder: (context, index) => ProductCardDriver(
                      product: userPreferences[index],
                      additionalSuffix: 'userPreferences',
                      openProductCardCallBack: onOpenProductCardCallBack,
                      index: index,
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 177),
                      child: Text(''),
                    ),
                  ),
            SliverPadding(
              padding: EdgeInsetsGeometry.only(
                bottom: MediaQuery.paddingOf(context).bottom + 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
