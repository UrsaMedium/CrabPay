import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/hero_flight_observer.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
import 'package:crabpay/views/main_screen/_sub/product_view/driver/product_cubit.dart';
import 'package:crabpay/views/main_screen/_sub/product_view/view/material/material_product_buy_layer.dart';
import 'package:crabpay/views/main_screen/_sub/product_view/view/material/material_product_description_layer.dart';
import 'package:crabpay/views/main_screen/_sub/product_view/view/material/material_product_view_appbar.dart';
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
  final VoidCallback onPageTransitionEnd;
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
    required this.onPageTransitionEnd,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.appColorScheme.surfaceContainerLow,
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
            final descPosition = context.select<ProductViewCubit, double?>(
              (cubit) => cubit.state.descPosition,
            );
            final buyPosition = context.select<ProductViewCubit, double?>(
              (cubit) => cubit.state.buyPosition,
            );
            final isPageReady = context.select<ProductViewCubit, bool>(
              (cubit) => cubit.state.isPageReady,
            );

            return Stack(
              children: [
                Column(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    HeroFlightObserverWithFallBack(
                      onHeroLanded: onPageTransitionEnd,
                      onHeroFlightStarted: () {},
                      builder: (context, onFlightStarted, onFlightEnded) {
                        return Hero(
                          tag: tag,
                          createRectTween: (begin, end) =>
                              MaterialRectArcTween(begin: begin, end: end),
                          flightShuttleBuilder:
                              (
                                flightContext,
                                animation,
                                flightDirection,
                                fromHeroContext,
                                toHeroContext,
                              ) {
                                return HeroFlightObserver(
                                  onFlightStarted: onFlightStarted,
                                  onFlightEnded: onFlightEnded,
                                  child: toHeroContext.widget,
                                );
                              },
                          child: ClipRRect(
                            borderRadius: .zero,
                            clipBehavior: .antiAlias,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOutCubic,
                              width: MediaQuery.widthOf(context),
                              height: isPageReady
                                  ? descPosition! + 24
                                  : MediaQuery.widthOf(context),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://regred-rainbowbridge.ru/crabpay/images/products/${context.read<ProductViewCubit>().state.product!.image}.png',
                                fit: BoxFit.cover,
                                errorWidget: (context, error, stackTrace) =>
                                    Container(
                                      color: context
                                          .appColorScheme
                                          .onInverseSurface,
                                      alignment: Alignment.center,
                                      child: Text('🦀'),
                                    ),
                                placeholder: (context, url) =>
                                    MaterialShimeringPlaceHolder(
                                      width: MediaQuery.widthOf(context),
                                      height: isPageReady
                                          ? descPosition! + 24
                                          : MediaQuery.widthOf(context),
                                      cornerRadius: 0,
                                      color: context
                                          .appColorScheme
                                          .surfaceContainerHigh,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: Container(
                        color: context.appColorScheme.surfaceContainerLow,
                      ),
                    ),
                  ],
                ),

                AnimatedPositioned(
                  top:
                      (isPageReady ? descPosition : buyPosition)! -
                              keyboardHeight <
                          MediaQuery.paddingOf(context).top
                      ? MediaQuery.paddingOf(context).top
                      : (isPageReady ? descPosition : buyPosition)! -
                            keyboardHeight,
                  left: 0,
                  right: 0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  child: MaterialProductDescriptionLayer(
                    isPageReady: isPageReady,
                    onScrollAction: (p0) => onScrollAction(p0),
                  ),
                ),

                AnimatedPositioned(
                  top:
                      (isPageReady
                                  ? buyPosition
                                  : MediaQuery.heightOf(context))! -
                              keyboardHeight <
                          MediaQuery.paddingOf(context).top
                      ? MediaQuery.paddingOf(context).top + 54
                      : (isPageReady
                                ? buyPosition
                                : MediaQuery.heightOf(context))! -
                            keyboardHeight,
                  left: 0,
                  right: 0,
                  height: context.read<ProductViewCubit>().state.buyLayerHeight,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  child: MaterialProductBuyLayer(
                    isPageReady: isPageReady,
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
