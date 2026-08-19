import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidgetDriver extends StatefulWidget {
  final Function(CartItem) onACartItemDelete;
  final Product product;
  final CartItem cartItem;
  final bool isBeingDeleted;
  const CartItemWidgetDriver({
    super.key,
    required this.onACartItemDelete,
    required this.product,
    required this.cartItem,
    required this.isBeingDeleted,
  });

  @override
  State<CartItemWidgetDriver> createState() => _CartItemWidgetDriverState();
}

class _CartItemWidgetDriverState extends State<CartItemWidgetDriver> {
  bool _isExpanded = false;
  String details = '';
  late final Color? surfaceTintColor;

  @override
  void initState() {
    for (var key in widget.cartItem.purchaseData.keys) {
      details += '$key: ${widget.cartItem.purchaseData[key]}\n';
    }
    details = details.trimRight();

    surfaceTintColor =
        context
                .read<DatabaseBloc>()
                .state
                .cachedProductImageDominantColor?[widget.product.id] ==
            null
        ? null
        : Color(
            context
                .read<DatabaseBloc>()
                .state
                .cachedProductImageDominantColor![widget.product.id]!,
          );
    super.initState();
  }

  void _setExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialCartItemWidget(
      cartItem: widget.cartItem,
      isBeingDeleted: widget.isBeingDeleted,
      onACartItemDelete: widget.onACartItemDelete,
      product: widget.product,
      isExpanded: _isExpanded,
      setExpanded: _setExpanded,
      details: details,
      surfaceTintColor: surfaceTintColor,
    );
  }
}

class MaterialCartItemWidget extends StatelessWidget {
  final Function(CartItem) onACartItemDelete;
  final Product product;
  final CartItem cartItem;
  final bool isBeingDeleted;
  final bool isExpanded;
  final VoidCallback setExpanded;
  final String details;
  final Color? surfaceTintColor;
  const MaterialCartItemWidget({
    super.key,
    required this.onACartItemDelete,
    required this.product,
    required this.cartItem,
    required this.isBeingDeleted,
    required this.isExpanded,
    required this.setExpanded,
    required this.details,
    this.surfaceTintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: setExpanded,
        child: Card(
          elevation: 3,
          surfaceTintColor: surfaceTintColor,
          clipBehavior: Clip.antiAlias,
          color: context.appColorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(39),
            side: BorderSide(
              color: context.appColorScheme.surfaceContainerHigh,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  curve: Curves.easeInOutCubic,
                  child: Row(
                    crossAxisAlignment: isExpanded ? .start : .center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://regred-rainbowbridge.ru/crabpay/images/products/${product.image}.png',
                          fit: .cover,
                          height: 54,
                          width: 54,
                          errorWidget: (context, error, stackTrace) =>
                              Container(
                                color: context.appColorScheme.onInverseSurface,
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color:
                                          context.appColorScheme.inversePrimary,
                                      size: 48,
                                    ),
                                    Text(error),
                                  ],
                                ),
                              ),
                          placeholder: (context, url) => Container(
                            color: context.appColorScheme.onInverseSurface,
                            alignment: .center,
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(product.name),
                              Text(
                                '${cartItem.checkoutPrice}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context.appColorScheme.primary,
                                  fontWeight: .w600,
                                ),
                              ),
                              if (isExpanded) Text(details),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: .only(right: 14, top: isExpanded ? 7 : 0),
                        height: 40,
                        width: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: context.appColorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          iconSize: 25,
                          padding: .all(0),
                          onPressed: () => onACartItemDelete(cartItem),
                          icon: Icon(Icons.delete_outline_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isBeingDeleted)
                BackdropFilter(
                  filter: .blur(sigmaX: 12, sigmaY: 12),
                  child: AbsorbPointer(
                    absorbing: true,
                    child: ClipRRect(
                      borderRadius: .circular(50),
                      child: Center(child: Text('Deleting')),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
