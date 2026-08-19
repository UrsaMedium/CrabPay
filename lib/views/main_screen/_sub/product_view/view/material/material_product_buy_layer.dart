import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/views/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/views/main_screen/_sub/product_view/driver/product_cubit.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MaterialProductBuyLayer extends StatelessWidget {
  final VoidCallback onResetImageFieldPressed;
  final VoidCallback onAddFieldPressed;
  final VoidCallback onDeleteLastAddedItem;
  final VoidCallback onCartIconPressed;
  final VoidCallback onAddCartItemPressed;
  final bool isPageReady;
  final Function(String, String) onUserInput;
  final Function(ScrollNotification) onScrollAction;
  const MaterialProductBuyLayer({
    super.key,
    required this.onResetImageFieldPressed,
    required this.onAddFieldPressed,
    required this.onDeleteLastAddedItem,
    required this.onCartIconPressed,
    required this.onAddCartItemPressed,
    required this.onUserInput,
    required this.onScrollAction,
    required this.isPageReady,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: context.read<ProductViewCubit>().state.buyLayerKey,
      decoration: BoxDecoration(
        color: context.appColorScheme.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: .circular(24)),
      ),
      clipBehavior: .antiAlias,

      child: Column(
        mainAxisSize: .min,
        children: [
          if (isPageReady)
            Stack(
              children: [
                Builder(
                  builder: (context) {
                    final layer = context
                        .select<ProductViewCubit, ProductViewLayers>(
                          (value) => value.state.layer,
                        );
                    final createBuyLayer = context
                        .select<ProductViewCubit, bool>(
                          (cubit) => cubit.state.createBuyLayer,
                        );
                    return !createBuyLayer
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 32.0,
                              top: 16,
                              bottom: 8,
                              right: 80,
                            ),
                            child: SizedBox(
                              child: Text(
                                'Read Description',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: .w700,
                                  color: context.appColorScheme.tertiary,
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            alignment: .bottomCenter,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.heightOf(context) * .7,
                                ),
                                child: MaterialBuyLayerFields(
                                  layer: layer,
                                  onScrollAction: (p0) => onScrollAction(p0),
                                  onUserInput: (p0, p1) => onUserInput(p0, p1),
                                ),
                              ),
                              if (layer == ProductViewLayers.buyLayer)
                                Positioned(
                                  top: 0,
                                  bottom: 4,
                                  left: 8,
                                  right: 8,
                                  child: Column(
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      MaterialBuyLayerCostDisplay(
                                        onAddFieldPressed: onAddFieldPressed,
                                        onResetImageFieldPressed:
                                            onResetImageFieldPressed,
                                      ),
                                      MaterialBuyLayerButtonRow(
                                        onAddCartItemPressed:
                                            onAddCartItemPressed,
                                        onCartIconPressed: onCartIconPressed,
                                        onDeleteLastAddedItem:
                                            onDeleteLastAddedItem,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                  },
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: .topCenter,
                    end: .bottomCenter,
                    colors: [
                      context.appColorScheme.outline.withValues(alpha: .6),
                      context.appColorScheme.outline.withValues(alpha: .3),
                      Colors.transparent,
                      Colors.transparent,
                    ],
                  ).createShader(bounds),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: .circular(22),
                      border: .all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class MaterialBuyLayerFields extends StatelessWidget {
  final Function(String, String) onUserInput;
  final Function(ScrollNotification) onScrollAction;
  final ProductViewLayers layer;
  const MaterialBuyLayerFields({
    super.key,
    required this.onUserInput,
    required this.onScrollAction,
    required this.layer,
  });

  @override
  Widget build(BuildContext context) {
    final fields = context.select<ProductViewCubit, List<ProductField>>(
      (cubit) => cubit.state.productFields ?? [],
    );

    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        onScrollAction(notification);

        return false;
      },
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: _fieldSlivers(context, fields),
      ),
    );
  }

  List<Widget> _fieldSlivers(BuildContext context, List<ProductField> fields) {
    fields.sort((a, b) => a.order.compareTo(b.order));
    List<Widget> result = [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32.0,
            top: 16,
            bottom: 8,
            right: 80,
          ),
          child: SizedBox(
            child: Text(
              layer != ProductViewLayers.buyLayer
                  ? 'Read Description'
                  : 'Fill Every Field',
              style: TextStyle(
                fontSize: 20,
                fontWeight: .w700,
                color: context.appColorScheme.tertiary,
              ),
            ),
          ),
        ),
      ),
    ];
    for (var field in fields) {
      result.add(
        SliverToBoxAdapter(
          child: context.read<ProductViewCubit>().state.isAdmin
              ? Stack(
                  children: [
                    theAppWidgetBuilder(
                      collectedDataBridge: (p0, p1) => onUserInput(p0, p1),
                      context: context,
                      fieldName: field.fieldName,
                      handler: field.handler,
                      priceImages: field.priceImages,
                      expectedData: field.expectedData,
                      isCupertino: false,
                    ),
                    Positioned(
                      right: 3,
                      child: Row(
                        children: [
                          if (field.isPriceImage)
                            IconButton(
                              onPressed: () {
                                context.pushNamed(
                                  'update_price_images_field_admin_panel_view',
                                  pathParameters: {
                                    'fieldId': field.id,
                                    'productId': context
                                        .read<ProductViewCubit>()
                                        .state
                                        .product!
                                        .id,
                                  },
                                );
                              },
                              icon: Icon(Icons.price_change_rounded),
                              color: context.appColorScheme.errorContainer,
                            ),
                          Text(
                            'Field\'s order - ${field.order}',
                            style: TextStyle(
                              color: context.appColorScheme.errorContainer,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.pushNamed(
                                'update_field_admin_panel_view',
                                pathParameters: {
                                  'fieldId': field.id,
                                  'productId': context
                                      .read<ProductViewCubit>()
                                      .state
                                      .product!
                                      .id,
                                },
                              );
                            },
                            icon: Icon(Icons.settings),
                            color: context.appColorScheme.errorContainer,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : theAppWidgetBuilder(
                  collectedDataBridge: (p0, p1) => onUserInput(p0, p1),
                  context: context,
                  fieldName: field.fieldName,
                  handler: field.handler,
                  priceImages: field.priceImages,
                  expectedData: field.expectedData,
                  isCupertino: false,
                ),
        ),
      );
    }
    result.add(SliverToBoxAdapter(child: SizedBox(height: 66)));
    return result;
  }
}

class MaterialBuyLayerButtonRow extends StatelessWidget {
  final VoidCallback onDeleteLastAddedItem;
  final VoidCallback onCartIconPressed;
  final VoidCallback onAddCartItemPressed;
  const MaterialBuyLayerButtonRow({
    super.key,
    required this.onDeleteLastAddedItem,
    required this.onCartIconPressed,
    required this.onAddCartItemPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: double.maxFinite,
        child: Builder(
          builder: (context) {
            final itemsCount = context.select<ProductViewCubit, int>(
              (cubit) => cubit.state.itemsInCart,
            );
            final isCartLoading = context.select<ProductViewCubit, bool>(
              (cubit) => cubit.state.isCartLoading,
            );
            final highGraphics = context.select<GlobalGraphicBloc, bool>(
              (bloc) => bloc.state.highGraphics,
            );
            return Row(
              children: [
                if (itemsCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: .circular(30),
                      child: BackdropFilter(
                        enabled: highGraphics,
                        filter: .blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          height: 45,
                          alignment: .center,
                          padding: .only(left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: context.appColorScheme.primary.withValues(
                              alpha: highGraphics ? .5 : .95,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: BoxBorder.all(
                              color: context.appColorScheme.outline,
                            ),
                          ),
                          child: Row(
                            children: [
                              isCartLoading
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                      onPressed: onDeleteLastAddedItem,
                                      icon: Icon(
                                        Icons.exposure_minus_1_rounded,
                                        color: context.appColorScheme.onPrimary,
                                      ),
                                    ),
                              VerticalDivider(width: 4),
                              IconButton(
                                onPressed: onCartIconPressed,
                                icon: Badge(
                                  backgroundColor:
                                      context.appColorScheme.onError,
                                  textColor: context.appColorScheme.error,
                                  label: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    transitionBuilder:
                                        (
                                          Widget child,
                                          Animation<double> animation,
                                        ) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(2, 0.0),
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: child,
                                            ),
                                          );
                                        },
                                    child: Text(
                                      '$itemsCount',
                                      key: ValueKey<int>(itemsCount),
                                    ),
                                  ),
                                  isLabelVisible: itemsCount > 0,
                                  child: Icon(
                                    color: context.appColorScheme.onPrimary,
                                    Icons.shopping_cart_checkout_rounded,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Flexible(
                  child: ClipRRect(
                    borderRadius: .circular(30),
                    child: BackdropFilter(
                      enabled: highGraphics,
                      filter: .blur(sigmaX: 12, sigmaY: 12),
                      child: Builder(
                        builder: (context) {
                          final isEveryFieldSatisfied = context
                              .select<ProductViewCubit, bool>(
                                (cubit) => cubit.state.isEveryFieldSatisfied,
                              );
                          return ElevatedButton(
                            onPressed: onAddCartItemPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isEveryFieldSatisfied
                                  ? context.appColorScheme.primary.withValues(
                                      alpha: highGraphics ? .5 : .95,
                                    )
                                  : context.appColorScheme.onPrimary.withValues(
                                      alpha: highGraphics ? .5 : .95,
                                    ),
                              foregroundColor: isEveryFieldSatisfied
                                  ? context.appColorScheme.onPrimary
                                  : context.appColorScheme.primary,
                              minimumSize: Size(double.maxFinite, 45),
                              side: BorderSide(
                                color: isEveryFieldSatisfied
                                    ? context.appColorScheme.primary.withValues(
                                        alpha: highGraphics ? .5 : .95,
                                      )
                                    : context.appColorScheme.onPrimary
                                          .withValues(
                                            alpha: highGraphics ? .5 : .95,
                                          ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Add To Cart',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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

class MaterialBuyLayerCostDisplay extends StatelessWidget {
  final VoidCallback onResetImageFieldPressed;
  final VoidCallback onAddFieldPressed;
  const MaterialBuyLayerCostDisplay({
    super.key,
    required this.onResetImageFieldPressed,
    required this.onAddFieldPressed,
  });

  @override
  Widget build(BuildContext context) {
    final highGraphics = context.select<GlobalGraphicBloc, bool>(
      (bloc) => bloc.state.highGraphics,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 16),
      child: Row(
        children: [
          Spacer(),
          if (context.read<ProductViewCubit>().state.isAdmin)
            Row(
              children: [
                IconButton(
                  onPressed: onResetImageFieldPressed,
                  icon: Icon(
                    Icons.price_check_rounded,
                    color: context.appColorScheme.errorContainer,
                  ),
                ),
                IconButton(
                  onPressed: onAddFieldPressed,
                  icon: Icon(
                    Icons.add,
                    color: context.appColorScheme.errorContainer,
                  ),
                ),
              ],
            ),
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(30),
            child: BackdropFilter(
              enabled: highGraphics,
              filter: .blur(sigmaX: 12, sigmaY: 12),
              child: Builder(
                builder: (context) {
                  final precalculatedPrice = context
                      .select<ProductViewCubit, double>(
                        (cubit) => cubit.state.precalculatedPrice,
                      );
                  return Container(
                    height: 44,
                    width: 100,
                    alignment: .center,
                    padding: .only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: precalculatedPrice == 0
                          ? context.appColorScheme.surfaceContainerHigh
                                .withValues(alpha: highGraphics ? .5 : .95)
                          : context.appColorScheme.onPrimary.withValues(
                              alpha: highGraphics ? .5 : .95,
                            ),
                      borderRadius: BorderRadius.circular(30),
                      border: BoxBorder.all(
                        color: precalculatedPrice == 0
                            ? context.appColorScheme.surfaceContainer
                                  .withValues(alpha: highGraphics ? .5 : .95)
                            : context.appColorScheme.onPrimary,
                      ),
                    ),
                    child: Text(
                      precalculatedPrice == 0 ? '--' : '\$$precalculatedPrice',
                      overflow: .clip,
                      style: TextStyle(color: context.appColorScheme.primary),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
