import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/product_card.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/home_page/driver/home_page_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialHomePageFavoriteContainer extends StatelessWidget {
  const MaterialHomePageFavoriteContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final userPreferences = context.select<HomePageCubit, List<Product>>(
      (cubit) => cubit.state.userPreferences ?? [],
    );
    final isInitialized = context.select<HomePageCubit, bool>(
      (cubit) => cubit.state.isInitialized,
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
                            tag:
                                '${userPreferences[index * 2].id}-favorite-$index',
                            width:
                                (context
                                        .read<HomePageCubit>()
                                        .state
                                        .containerWidth -
                                    24) /
                                2,
                            cornerRadius: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                : !isInitialized
                ? _PlaceHolder()
                : SizedBox(),
            Column(
              mainAxisSize: .min,
              children: [
                Container(
                  width:
                      (context.read<HomePageCubit>().state.containerWidth -
                          24) /
                      2,
                  margin: .only(
                    bottom: (isInitialized && userPreferences.isEmpty) ? 0 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: .circular(16),
                    color: context.appColorScheme.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (isInitialized && userPreferences.isEmpty)
                            ? context.l10n.favoriteEmpty
                            : context.l10n.favorite,
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
                        tag:
                            '${userPreferences[index * 2 + 1].id}-favorite-$index',
                        width:
                            (context
                                    .read<HomePageCubit>()
                                    .state
                                    .containerWidth -
                                24) /
                            2,
                        cornerRadius: 16,
                      ),
                    ),
                  ),
                if (userPreferences.isEmpty && !isInitialized) _PlaceHolder(),
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
      width: (context.read<HomePageCubit>().state.containerWidth - 24) / 2,
    );
  }
}
