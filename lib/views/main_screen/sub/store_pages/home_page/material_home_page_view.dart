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
    final featuredContainerHalfWidth =
        MediaQuery.sizeOf(context).width / 2 - 28;
    return RefreshIndicator(
      edgeOffset: MediaQuery.paddingOf(context).top + 40,
      onRefresh: reFresher,
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsetsGeometry.only(
                top: MediaQuery.paddingOf(context).top + 48 + 16,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.appColorScheme.tertiaryContainer,
                    borderRadius: .circular(24),
                  ),
                  height: 330,
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
                                    width: featuredContainerHalfWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: .circular(16),
                                      color: context
                                          .appColorScheme
                                          .onTertiaryContainer,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Featured Deals',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: .w700,
                                            color: context
                                                .appColorScheme
                                                .tertiaryContainer,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: featuredContainerHalfWidth,
                                    // height: 300 - 68,
                                    child: ProductCardDriver(
                                      openProductCardCallBack:
                                          openProductCardCallBack,
                                      product: featuredProducts[0],
                                      additionalSuffix: 'featuredProduct',
                                      index: 0,
                                      imageHeight: 190 - 15,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                spacing: 8,
                                crossAxisAlignment: .start,
                                children: [
                                  SizedBox(
                                    width: featuredContainerHalfWidth,
                                    // height: 300 - 68,
                                    child: ProductCardDriver(
                                      openProductCardCallBack:
                                          openProductCardCallBack,
                                      product: featuredProducts[1],
                                      additionalSuffix: 'featuredProduct',
                                      index: 1,
                                      imageHeight: 64,
                                    ),
                                  ),
                                  SizedBox(
                                    width: featuredContainerHalfWidth,
                                    // height: 300 - 68,
                                    child: ProductCardDriver(
                                      openProductCardCallBack:
                                          openProductCardCallBack,
                                      product: featuredProducts[2],
                                      additionalSuffix: 'featuredProduct',
                                      index: 2,
                                      imageHeight: 64,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            SliverPadding(
              padding: .symmetric(horizontal: 34, vertical: 6),
              sliver: SliverToBoxAdapter(child: Divider()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.appColorScheme.surfaceContainer,
                    borderRadius: .circular(24),
                  ),
                  child: Stack(
                    children: [
                      userPreferences.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomScrollView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                slivers: [
                                  SliverCrossAxisGroup(
                                    slivers: [
                                      SliverPadding(
                                        padding: .only(right: 4),
                                        sliver: SliverCrossAxisExpanded(
                                          flex: 1,
                                          sliver: SliverList.builder(
                                            itemCount:
                                                (userPreferences.length + 1) ~/
                                                2,
                                            itemBuilder: (context, index) =>
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 8.0,
                                                      ),
                                                  child: ProductCardDriver(
                                                    product:
                                                        userPreferences[index *
                                                            2],
                                                    additionalSuffix:
                                                        'favorite',
                                                    openProductCardCallBack:
                                                        onOpenProductCardCallBack,
                                                    index: index,
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
                                            itemCount:
                                                userPreferences.length ~/ 2,
                                            itemBuilder: (context, index) =>
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: index == 0 ? 50 : 8,
                                                  ),
                                                  child: ProductCardDriver(
                                                    product:
                                                        userPreferences[index *
                                                                2 +
                                                            1],
                                                    additionalSuffix:
                                                        'favorite',
                                                    openProductCardCallBack:
                                                        onOpenProductCardCallBack,
                                                    index: index,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 8,
                                bottom: 20,
                              ),
                              child: Text('You haven\'t picked favorite'),
                            ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                          left: featuredContainerHalfWidth + 16,
                        ),
                        child: Container(
                          width: featuredContainerHalfWidth,
                          decoration: BoxDecoration(
                            borderRadius: .circular(16),
                            color: context.appColorScheme.secondaryContainer,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Favorites',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: .w700,
                                  color: context
                                      .appColorScheme
                                      .onSecondaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsetsGeometry.only(
                bottom: MediaQuery.paddingOf(context).bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
