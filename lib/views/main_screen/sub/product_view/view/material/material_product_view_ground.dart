import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/main_screen/sub/product_view/driver/product_cubit.dart';
import 'package:crabpay/views/main_screen/sub/product_view/view/material/material_product_buy_layer.dart';
import 'package:crabpay/views/main_screen/sub/product_view/view/material/material_product_description_layer.dart';
import 'package:crabpay/views/main_screen/sub/product_view/view/material/material_product_view_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialProductView extends StatelessWidget {
  final String tag;
  final VoidCallback onBackButtonPressed;
  final VoidCallback onAdminProductPanelPressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback onResetImageFieldPressed;
  final VoidCallback onAddFieldPressed;
  final VoidCallback onDeleteLastAddedItem;
  final VoidCallback onCartIconPressed;
  final VoidCallback onAddCartItemPressed;
  final Function(String, String) onUserInput;
  final Function(DragEndDetails) onVerticalSwipe;
  final Function(ScrollNotification) onScrollAction;
  const MaterialProductView({
    super.key,
    required this.tag,
    required this.onBackButtonPressed,
    required this.onAdminProductPanelPressed,
    required this.onFavoritePressed,
    required this.onVerticalSwipe,
    required this.onResetImageFieldPressed,
    required this.onAddFieldPressed,
    required this.onDeleteLastAddedItem,
    required this.onCartIconPressed,
    required this.onAddCartItemPressed,
    required this.onUserInput,
    required this.onScrollAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColorScheme.surfaceContainerLowest,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MaterialProductViewAppbar(
        onBackButtonPressed: onBackButtonPressed,
        onAdminProductPanelPressed: onAdminProductPanelPressed,
        onFavoritePressed: onFavoritePressed,
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) => onVerticalSwipe(details),
        child: Builder(
          builder: (context) {
            final descPosition = context.select<ProductViewCubit, double>(
              (cubit) => cubit.state.descPosition,
            );
            final buyPosition = context.select<ProductViewCubit, double>(
              (cubit) => cubit.state.buyPosition,
            );
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Hero(
                      tag: tag,
                      createRectTween: (begin, end) =>
                          MaterialRectArcTween(begin: begin, end: end),
                      child: ClipRRect(
                        borderRadius: .zero,
                        clipBehavior: .antiAlias,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOutCubic,
                          width:
                              context
                                  .read<ProductViewCubit>()
                                  .state
                                  .layoutBoundries?['width'] ??
                              double.maxFinite,
                          height: descPosition + 24,
                          // alignment: .center,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://regred-rainbowbridge.ru/crabpay/images/products/${context.read<ProductViewCubit>().state.product!.image}.png',
                            // width: MediaQuery.widthOf(context),
                            // height: descPosition,
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) =>
                                Container(
                                  color:
                                      context.appColorScheme.onInverseSurface,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.broken_image,
                                    color:
                                        context.appColorScheme.inversePrimary,
                                    size: 48,
                                  ),
                                ),
                            placeholder: (context, url) => Container(
                              color: context.appColorScheme.onInverseSurface,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.heightOf(context) / 2 - 128,
                      color: context.appColorScheme.surfaceContainerLow,
                    ),
                  ],
                ),
                AnimatedPositioned(
                  top: descPosition,
                  left: 0,
                  right: 0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  child: MaterialProductDescriptionLayer(
                    onScrollAction: (p0) => onScrollAction(p0),
                  ),
                ),
                AnimatedPositioned(
                  top: buyPosition,
                  left: 0,
                  right: 0,
                  height: context.read<ProductViewCubit>().state.buyLayerHeight,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  child: MaterialProductBuyLayer(
                    onScrollAction: (p0) => onScrollAction(p0),
                    onResetImageFieldPressed: onResetImageFieldPressed,
                    onAddFieldPressed: onAddFieldPressed,
                    onDeleteLastAddedItem: onDeleteLastAddedItem,
                    onCartIconPressed: onCartIconPressed,
                    onAddCartItemPressed: onAddCartItemPressed,
                    onUserInput: (p0, p1) => onUserInput(p0, p1),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
