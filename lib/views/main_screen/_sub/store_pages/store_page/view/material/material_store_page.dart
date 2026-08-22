import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/driver/store_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialStorePage extends StatelessWidget {
  final Future<void> Function() reFresher;
  final Function(String) onCategoryViewOpen;
  const MaterialStorePage({
    super.key,
    required this.reFresher,
    required this.onCategoryViewOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            edgeOffset: MediaQuery.paddingOf(context).top,
            onRefresh: reFresher,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: .only(
                      top: 32,
                      bottom: MediaQuery.paddingOf(context).bottom + 32,
                    ),
                  ),
                  SliverList.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) => _CategoryCard(
                      index: index,
                      onCategoryViewOpen: (tag) => onCategoryViewOpen(tag),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Function(String) onCategoryViewOpen;
  final int index;
  const _CategoryCard({required this.index, required this.onCategoryViewOpen});

  @override
  Widget build(BuildContext context) {
    final highGraphics = context.select<GlobalGraphicBloc, bool>(
      (bloc) => bloc.state.highGraphics,
    );
    final products = context.select<StorePageCubit, List<Product>>(
      (cubit) => (cubit.state.products ?? [])
          .where(
            (element) =>
                element.category == (index == 0 ? 'Mobile Game' : 'Service'),
          )
          .toList(),
    );
    return Card(
      margin: .only(bottom: 32),
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      surfaceTintColor: context.appColorScheme.primary,
      color: context.appColorScheme.surfaceContainerHigh,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  index == 0 ? 'Mobile Games' : 'Services',
                  style: TextStyle(
                    color: context.appColorScheme.secondary,
                    fontSize: 20,
                    fontWeight: .bold,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Stack(
              alignment: .bottomCenter,
              children: [
                SizedBox(
                  height: 128,
                  width: MediaQuery.widthOf(context) - 32,
                  child: ListView.builder(
                    itemCount: products.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => _ProductImage(
                      product: products[index],
                      tag: index == 0 ? 'Mobile Game' : 'Service',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Spacer(),
                      Material(
                        color: Colors.transparent,
                        borderRadius: .circular(24),
                        clipBehavior: .antiAlias,
                        child: BackdropFilter(
                          enabled: highGraphics,
                          filter: .blur(sigmaX: 12, sigmaY: 12),
                          child: GestureDetector(
                            onTap: () => onCategoryViewOpen(
                              index == 0 ? 'Mobile Game' : 'Service',
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.appColorScheme.secondaryContainer
                                    .withValues(alpha: highGraphics ? .4 : .9),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: context
                                        .appColorScheme
                                        .onSecondaryContainer,
                                  ),
                                ),
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
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Product product;
  final String tag;
  const _ProductImage({required this.product, required this.tag});

  @override
  Widget build(BuildContext context) {
    final heroTag = '${product.id}-$tag';
    return GestureDetector(
      onTap: () => globalOpenProductCardCallBack(
        context: context,
        productId: product.id,
        tag: heroTag,
      ),
      child: Container(
        margin: .symmetric(horizontal: 4),
        height: 40,
        width: 64,
        decoration: BoxDecoration(borderRadius: .circular(4)),
        clipBehavior: .antiAlias,
        child: Hero(
          tag: heroTag,
          createRectTween: (begin, end) =>
              MaterialRectArcTween(begin: begin, end: end),
          child: CachedNetworkImage(
            imageUrl:
                'https://regred-rainbowbridge.ru/crabpay/images/products/${product.image}.png',
            fit: .cover,
            errorWidget: (context, error, stackTrace) => Container(
              color: context.appColorScheme.onInverseSurface,
              alignment: Alignment.center,
              child: Text('🦀'),
            ),
            placeholder: (context, url) => MaterialShimeringPlaceHolder(
              width: 40,
              height: 40,
              cornerRadius: 4,
              color: context.appColorScheme.surfaceContainerHigh,
            ),
          ),
        ),
      ),
    );
  }
}
