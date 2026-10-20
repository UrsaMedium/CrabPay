import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/product_card_horizontal.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/product_card_small.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/home_page/driver/home_page_cubit.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/product_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MaterialHomePageFeaturedContainer extends StatelessWidget {
  const MaterialHomePageFeaturedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredProducts = context.select<HomePageCubit, List<Product>>(
      (cubit) => cubit.state.featuredProducts ?? [],
    );
    return Container(
      decoration: BoxDecoration(
        color: context.appColorScheme.tertiaryContainer,
        // color: Colors.black,
        borderRadius: .circular(
          context.read<HomePageCubit>().state.outerCornerRadius,
        ),
      ),
      // height: context.read<HomePageCubit>().state.containerWidth,
      width: context.read<HomePageCubit>().state.containerWidth,
      child: featuredProducts.isNotEmpty
          ? Padding(
              padding: .all(
                context.read<HomePageCubit>().state.containerPadding,
              ),
              child: Column(
                spacing: context.read<HomePageCubit>().state.containerPadding / 2,
                children: [
                  SizedBox(
                    width: context.read<HomePageCubit>().state.containerWidth,
                    height: ((context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2) * 1.5 + 2,
                    child: Row(
                      crossAxisAlignment: .start,
                      spacing: context.read<HomePageCubit>().state.containerPadding / 2,
                      children: [
                        Column(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Container(
                              width: (context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2,
                              height:
                                  (((context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2) * 1.5 + 2) -
                                  (((context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2) * 1.25) -
                                  (context.read<HomePageCubit>().state.containerPadding / 2),
                              decoration: BoxDecoration(
                                borderRadius: .circular(
                                  context.read<HomePageCubit>().state.outerCornerRadius - context.read<HomePageCubit>().state.containerPadding / 2,
                                ),
                                color: context.appColorScheme.onTertiaryContainer,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    context.l10n.featuredndeals,
                                    textAlign: .center,
                                    style: TextStyle(
                                      fontSize: (context.read<HomePageCubit>().state.containerWidth - 24) / 36,
                                      fontWeight: .w700,
                                      color: context.appColorScheme.tertiaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ProductCardSmallDriver(
                              padding: 4,
                              product: featuredProducts[0],
                              tag: '${featuredProducts[0].id}-featuredProduct-0',
                              width: (context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2,
                              cornerRadius: context.read<HomePageCubit>().state.outerCornerRadius - context.read<HomePageCubit>().state.containerPadding / 2,
                            ),
                          ],
                        ),
                        if (featuredProducts.length > 1)
                          ProductCardDriver(
                            product: featuredProducts[2],
                            tag: '${featuredProducts[2].id}-featuredProduct-2',
                            width: (context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2,
                            cornerRadius: context.read<HomePageCubit>().state.outerCornerRadius - context.read<HomePageCubit>().state.containerPadding / 2,
                          ),
                      ],
                    ),
                  ),
                  ProductCardHorizontalDriver(
                    product: featuredProducts[1],
                    tag: '${featuredProducts[1].id}-featuredProduct-1',
                    height: (context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2) / 2,
                    width: context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2,
                    cornerRadius: context.read<HomePageCubit>().state.outerCornerRadius - context.read<HomePageCubit>().state.containerPadding / 2,
                  ),
                ],
              ),
            )
          : _PlaceHolder(),
    );
  }
}

class _PlaceHolder extends StatelessWidget {
  const _PlaceHolder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(
        context.read<HomePageCubit>().state.containerPadding,
      ),
      child: Column(
        spacing: context.read<HomePageCubit>().state.containerPadding / 2,
        children: [
          SizedBox(
            width: context.read<HomePageCubit>().state.containerWidth,
            height: ((context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2) * 1.5 + 2,
            child: Row(
              crossAxisAlignment: .start,
              spacing: context.read<HomePageCubit>().state.containerPadding / 2,
              children: [
                Column(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Container(
                      width: (context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2,
                      height:
                          (((context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2) * 1.5 + 2) -
                          (((context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2) * 1.25) -
                          (context.read<HomePageCubit>().state.containerPadding / 2),
                      decoration: BoxDecoration(
                        borderRadius: .circular(
                          context.read<HomePageCubit>().state.outerCornerRadius - context.read<HomePageCubit>().state.containerPadding / 2,
                        ),
                        color: context.appColorScheme.onTertiaryContainer,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            context.l10n.featuredndeals,
                            textAlign: .center,
                            style: TextStyle(
                              fontSize: (context.read<HomePageCubit>().state.containerWidth - 24) / 36,
                              fontWeight: .w700,
                              color: context.appColorScheme.tertiaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    MaterialShimeringPlaceHolder(
                      color: context.appColorScheme.surfaceContainerHigh,
                      shimeringColor: context.appColorScheme.outline,
                      cycleLongevityFactor: 278 * 10,
                      height: ((context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2) * 1.25,
                      width: (context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2,
                      cornerRadius: context.read<HomePageCubit>().state.outerCornerRadius - context.read<HomePageCubit>().state.containerPadding / 2,
                    ),
                  ],
                ),
                MaterialShimeringPlaceHolder(
                  color: context.appColorScheme.surfaceContainerHigh,
                  shimeringColor: context.appColorScheme.outline,
                  cycleLongevityFactor: 278 * 10,
                  height: ((context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2) * 1.5 + 2,
                  width: (context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2.5) / 2,
                  cornerRadius: context.read<HomePageCubit>().state.outerCornerRadius - context.read<HomePageCubit>().state.containerPadding / 2,
                ),
              ],
            ),
          ),
          MaterialShimeringPlaceHolder(
            color: context.appColorScheme.surfaceContainerHigh,
            shimeringColor: context.appColorScheme.outline,
            cycleLongevityFactor: 278 * 10,
            height: (context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2) / 2,
            width: context.read<HomePageCubit>().state.containerWidth - context.read<HomePageCubit>().state.containerPadding * 2,
            cornerRadius: context.read<HomePageCubit>().state.outerCornerRadius - context.read<HomePageCubit>().state.containerPadding / 2,
          ),
        ],
      ),
    );
  }
}
