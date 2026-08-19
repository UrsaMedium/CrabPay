import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/product_card.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/home_page/driver/home_page_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialHomePageFavoriteContainer extends StatelessWidget {
  final OnOpenProductCardCallBack onOpenProductCardCallBack;
  const MaterialHomePageFavoriteContainer({
    super.key,
    required this.onOpenProductCardCallBack,
  });

  @override
  Widget build(BuildContext context) {
    final userPreferences = context.select<HomePageCubit, List<Product>>(
      (cubit) => cubit.state.userPreferences ?? [],
    );
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
            userPreferences.isNotEmpty
                ? Column(
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
                            width: context
                                .read<HomePageCubit>()
                                .state
                                .containerHalfWidth,
                            cornerRadius: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                : _PlaceHolder(),
            Column(
              mainAxisSize: .min,
              children: [
                Container(
                  width: context.read<HomePageCubit>().state.containerHalfWidth,
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
                if (userPreferences.isNotEmpty)
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
                        width: context
                            .read<HomePageCubit>()
                            .state
                            .containerHalfWidth,
                        cornerRadius: 16,
                      ),
                    ),
                  ),
                if (userPreferences.isEmpty) _PlaceHolder(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceHolder extends StatelessWidget {
  const _PlaceHolder();

  @override
  Widget build(BuildContext context) {
    return MaterialShimeringPlaceHolder(
      color: context.appColorScheme.surfaceContainerHigh,
      shimeringColor: context.appColorScheme.outline,
      cycleLongevityFactor: 278 * 10,
      cornerRadius: 16,
      height: 256,
      width: context.read<HomePageCubit>().state.containerHalfWidth,
    );
  }
}
