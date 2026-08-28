import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/_sub/store_page_search/driver/store_search_bar_driver.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/driver/store_page_cubit.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/product_card_small.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MaterialStorePage extends StatelessWidget {
  final Future<void> Function() reFresher;
  final Function(String) onCategoryViewOpen;
  final Function(List<Product>) onSearchSubmitedCallBack;
  const MaterialStorePage({
    super.key,
    required this.reFresher,
    required this.onCategoryViewOpen,
    required this.onSearchSubmitedCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: .topRight,
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
                      top: 44,
                      bottom: MediaQuery.paddingOf(context).bottom + 56,
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
          Padding(
            padding: .only(
              top: MediaQuery.paddingOf(context).top + 8,
              left: 16,
            ),
            child: MaterialStoreSearchBarDriver(
              products: context.read<DatabaseBloc>().state.products ?? [],
              onSearchSubmitedCallBack: (prdcts) =>
                  onSearchSubmitedCallBack(prdcts),
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
    final subTag = index == 0 ? 'Mobile Game' : 'Service';
    return GestureDetector(
      onTap: () => onCategoryViewOpen(subTag),
      child: Card(
        margin: .only(bottom: 32),
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
        surfaceTintColor: context.appColorScheme.primary,
        color: context.appColorScheme.surfaceContainerHigh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                children: [
                  Text(
                    index == 0
                        ? context.l10n.mobileGames
                        : context.l10n.services,
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
            SizedBox(
              height: 64 * 1.25 + 16 + 8,
              width: MediaQuery.widthOf(context) - 32,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Stack(
                  alignment: .bottomEnd,
                  children: [
                    ListView.builder(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => ProductCardSmallDriver(
                        product: products[index],
                        tag: subTag,
                        width: 64,
                        cornerRadius: 4,
                        padding: 0,
                        margin: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          Spacer(),
                          Hero(
                            tag: subTag,
                            createRectTween: (begin, end) =>
                                MaterialRectArcTween(begin: begin, end: end),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: .circular(24),
                              clipBehavior: .antiAlias,
                              child: BackdropFilter(
                                enabled: highGraphics,
                                filter: .blur(sigmaX: 12, sigmaY: 12),
                                child: GestureDetector(
                                  onTap: () => onCategoryViewOpen(subTag),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: context
                                          .appColorScheme
                                          .secondaryContainer
                                          .withValues(
                                            alpha: highGraphics ? .4 : .9,
                                          ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        context.l10n.more,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
