import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/views/widgets/widget_factory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class MaterialBuyBottomSheet extends StatelessWidget {
  final Product product;
  final List<ProductField> productFields;
  final double precalculatedPrice;
  final bool haveImageField;
  final int itemsCount;
  final bool isEveryFieldSatisfied;
  final bool isAdmin;
  final VoidCallback onResetImageFieldPressed;
  final VoidCallback onAddFieldPressed;
  final VoidCallback onDeleteLastAddedItem;
  final VoidCallback onCartIconPressed;
  final VoidCallback onAddCartItemPressed;
  final Function(String, String) onUserInput;
  const MaterialBuyBottomSheet({
    super.key,
    required this.product,
    required this.productFields,
    required this.precalculatedPrice,
    required this.itemsCount,
    required this.isEveryFieldSatisfied,
    required this.isAdmin,
    required this.onResetImageFieldPressed,
    required this.onAddFieldPressed,
    required this.onDeleteLastAddedItem,
    required this.onCartIconPressed,
    required this.onAddCartItemPressed,
    required this.onUserInput,
    required this.haveImageField,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            border: Border.all(
              color: context.appColorScheme.surfaceContainerLow.withValues(
                alpha: .5,
              ),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ClipRRect(
                  borderRadius: .only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: BackdropFilter(
                    filter: .blur(sigmaX: 16, sigmaY: 16),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.58,
                                ),
                                child: Stack(
                                  children: [
                                    CustomScrollView(
                                      shrinkWrap: true,
                                      slivers: _fieldSlivers(
                                        fields: productFields,
                                        context: context,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 16,
                          child: Row(
                            children: [
                              if (isAdmin)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          onResetImageFieldPressed(),
                                      icon: Icon(
                                        Icons.price_check_rounded,
                                        color: context
                                            .appColorScheme
                                            .errorContainer,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => onAddFieldPressed(),
                                      icon: Icon(
                                        Icons.add,
                                        color: context
                                            .appColorScheme
                                            .errorContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(30),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: Container(
                                    height: 44,
                                    width: 100,
                                    alignment: .center,
                                    padding: .only(left: 16, right: 16),
                                    decoration: BoxDecoration(
                                      color: precalculatedPrice == 0
                                          ? context
                                                .appColorScheme
                                                .surfaceContainerHigh
                                                .withValues(alpha: .5)
                                          : context.appColorScheme.onPrimary
                                                .withValues(alpha: .5),
                                      borderRadius: BorderRadius.circular(30),
                                      border: BoxBorder.all(
                                        color: precalculatedPrice == 0
                                            ? context
                                                  .appColorScheme
                                                  .surfaceContainer
                                                  .withValues(alpha: .5)
                                            : context.appColorScheme.onPrimary,
                                      ),
                                    ),
                                    child: Text(
                                      precalculatedPrice == 0
                                          ? '--'
                                          : '\$$precalculatedPrice',
                                      overflow: .clip,
                                      style: TextStyle(
                                        color: context.appColorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 14,
                          left: 16,
                          right: 16,
                          child: BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        if (itemsCount > 0)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: .circular(30),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 5,
                                                  sigmaY: 5,
                                                ),
                                                child: Container(
                                                  height: 45,
                                                  alignment: .center,
                                                  padding: .only(
                                                    left: 16,
                                                    right: 16,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: context
                                                        .appColorScheme
                                                        .primary
                                                        .withValues(alpha: .5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                    border: BoxBorder.all(
                                                      color: context
                                                          .appColorScheme
                                                          .outline,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () =>
                                                            onDeleteLastAddedItem(),
                                                        icon: Icon(
                                                          Icons
                                                              .exposure_minus_1_rounded,
                                                          color: context
                                                              .appColorScheme
                                                              .onPrimary,
                                                        ),
                                                      ),
                                                      VerticalDivider(width: 4),
                                                      IconButton(
                                                        onPressed: () =>
                                                            onCartIconPressed(),
                                                        icon: Badge(
                                                          backgroundColor:
                                                              context
                                                                  .appColorScheme
                                                                  .onError,
                                                          textColor: context
                                                              .appColorScheme
                                                              .error,
                                                          label: AnimatedSwitcher(
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      250,
                                                                ),
                                                            transitionBuilder:
                                                                (
                                                                  Widget child,
                                                                  Animation<
                                                                    double
                                                                  >
                                                                  animation,
                                                                ) {
                                                                  return FadeTransition(
                                                                    opacity:
                                                                        animation,
                                                                    child: SlideTransition(
                                                                      position:
                                                                          Tween<Offset>(
                                                                            begin: const Offset(
                                                                              2,
                                                                              0.0,
                                                                            ),
                                                                            end:
                                                                                Offset.zero,
                                                                          ).animate(
                                                                            animation,
                                                                          ),
                                                                      child:
                                                                          child,
                                                                    ),
                                                                  );
                                                                },
                                                            child: Text(
                                                              '$itemsCount',
                                                              key:
                                                                  ValueKey<int>(
                                                                    itemsCount,
                                                                  ),
                                                            ),
                                                          ),
                                                          isLabelVisible:
                                                              itemsCount > 0,
                                                          child: Icon(
                                                            color: context
                                                                .appColorScheme
                                                                .onPrimary,
                                                            Icons
                                                                .shopping_cart_checkout_rounded,
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
                                              filter: ImageFilter.blur(
                                                sigmaX: 10.0,
                                                sigmaY: 10.0,
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    onAddCartItemPressed(),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      isEveryFieldSatisfied
                                                      ? context
                                                            .appColorScheme
                                                            .primary
                                                            .withValues(
                                                              alpha: .5,
                                                            )
                                                      : context
                                                            .appColorScheme
                                                            .onPrimary
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ),
                                                  foregroundColor:
                                                      isEveryFieldSatisfied
                                                      ? context
                                                            .appColorScheme
                                                            .onPrimary
                                                      : context
                                                            .appColorScheme
                                                            .primary,
                                                  minimumSize: Size(
                                                    double.maxFinite,
                                                    45,
                                                  ),
                                                  side: BorderSide(
                                                    color: isEveryFieldSatisfied
                                                        ? context
                                                              .appColorScheme
                                                              .primary
                                                              .withValues(
                                                                alpha: .5,
                                                              )
                                                        : context
                                                              .appColorScheme
                                                              .onPrimary
                                                              .withValues(
                                                                alpha: 0.5,
                                                              ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  isEveryFieldSatisfied
                                                      ? 'Add To Cart'
                                                      : 'Fill The Fields',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
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
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!haveImageField)
                Container(
                  color: context.appColorScheme.errorContainer.withValues(
                    alpha: .7,
                  ),
                  child: Text('Critical Error, ImageField issue}'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _fieldSlivers({
    required List<ProductField> fields,
    required BuildContext context,
  }) {
    fields.sort((a, b) => a.order.compareTo(b.order));
    List<Widget> result = [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32.0,
            top: 16,
            bottom: 8,
            right: 128,
          ),
          child: SizedBox(
            child: Text(
              product.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: .w700,
                color: context.appColorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    ];
    for (var field in fields) {
      result.add(
        SliverToBoxAdapter(
          child: isAdmin
              ? Stack(
                  children: [
                    theAppWidgetBuilder(
                      collectedDataBridge: onUserInput,
                      context: context,
                      fieldName: field.fieldName,
                      handler: field.handler,
                      priceImages: field.priceImages,
                      expectedData: field.expectedData,
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
                                  pathParameters: {'fieldId': field.id},
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
                                pathParameters: {'fieldId': field.id},
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
                  collectedDataBridge: onUserInput,
                  context: context,
                  fieldName: field.fieldName,
                  handler: field.handler,
                  priceImages: field.priceImages,
                  expectedData: field.expectedData,
                ),
        ),
      );
    }
    result.add(SliverToBoxAdapter(child: SizedBox(height: 66)));
    return result;
  }
}
