import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/_sub/product_view/driver/product_cubit.dart';
import 'package:crabpay/views/main_screen/_sub/product_view/view/material/material_product_view_ground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ProductViewDriver extends StatefulWidget {
  static const routeName = 'card_view';
  final String productId; //also tag identoty
  final String tag;
  const ProductViewDriver({
    super.key,
    required this.productId,
    required this.tag,
  });

  @override
  State<ProductViewDriver> createState() => _ProductViewDriverState();
}

class _ProductViewDriverState extends State<ProductViewDriver> {
  late final ProductViewCubit _productViewCubit;
  late final String heroTag;

  @override
  void initState() {
    heroTag = widget.tag;
    final theProduct = context
        .read<DatabaseBloc>()
        .state
        .products
        ?.where((aProduct) => aProduct.id == widget.productId)
        .firstOrNull;

    if (theProduct == null) {
      context.go(AppRoutes.home.path);
    }

    context.read<CartBloc>().add(
      CartEventFetchProductCartItemAmount(
        userId: context.read<AuthBloc>().state.currentUser.id,
        productId: theProduct!.id,
      ),
    );

    final productFields = context
        .read<DatabaseBloc>()
        .state
        .cachedProductFields?[widget.productId];

    final tintColor = context
        .read<DatabaseBloc>()
        .state
        .cachedProductImageDominantColor?[theProduct.id];

    _productViewCubit = ProductViewCubit(
      databaseBloc: context.read<DatabaseBloc>(),
      cartBloc: context.read<CartBloc>(),
      isAdmin: context.read<AuthBloc>().state.currentUser.isAdmin,
      isAnonymous: context.read<AuthBloc>().state.currentUser.isAnonymous,
      userId: context.read<AuthBloc>().state.currentUser.id,
      product: theProduct,
      productFields: productFields,
      tintColor: tintColor == null ? null : Color(tintColor),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final layoutBoundries = {
      'height': MediaQuery.heightOf(context),
      'width': MediaQuery.widthOf(context),
      'paddingTop': MediaQuery.paddingOf(context).top,
      'paddingBottom':
          View.of(context).padding.bottom / View.of(context).devicePixelRatio,
    };
    _productViewCubit.setLayoutBoundries(layoutBoundries);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _productViewCubit.close();
    super.dispose();
  }

  // admin
  void _onAdminProductPanelPressed() {
    context.pushNamed(
      AppRoutes.updateProduct.name,
      pathParameters: {'productId': widget.productId},
    );
  }

  void _onResetImageFieldPressed(BuildContext context) {
    context.pushNamed(
      AppRoutes.resetPriceImage.path,
      pathParameters: {'productId': _productViewCubit.state.product!.id},
    );
  }

  void _onAddFieldPressed(BuildContext context) {
    context.pushNamed(
      AppRoutes.addField.path,
      pathParameters: {'productId': _productViewCubit.state.product!.id},
    );
  }

  //admin

  void _onVerticalSwipe(DragEndDetails? details, BuildContext context) {
    if (details != null) {
      if ((details.primaryVelocity ?? 0) < -200) {
        _productViewCubit.setLayer(true);
      } else if ((details.primaryVelocity ?? 0) > 200) {
        if (_productViewCubit.state.layer ==
                ProductViewLayers.descriptionLayer ||
            _productViewCubit.state.layer == ProductViewLayers.groundLayer) {
          context.pop();
        }
        _productViewCubit.setLayer(false);
      }
    }
  }

  void _onBackButtonPressed() {
    if (GoRouter.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home.path);
    }
  }

  void _onFavoritePressed(BuildContext context) {
    if (_productViewCubit.state.isAnonymous) {
      Fluttertoast.showToast(msg: context.l10n.signIn);
      return;
    }
    if (_productViewCubit.state.isFavoriteLoading) {
      Fluttertoast.showToast(msg: context.l10n.pleaseWait);
      return;
    }
    _productViewCubit.setFavoriteLoadingStateTrue();
    if (_productViewCubit.state.isFavorite) {
      context.read<DatabaseBloc>().add(
        DatabaseEventDeleteUserPreference(
          product: _productViewCubit.state.product!,
          userId: _productViewCubit.state.userId!,
        ),
      );
    } else {
      context.read<DatabaseBloc>().add(
        DatabaseEventAddUserPreference(
          product: _productViewCubit.state.product!,
          userId: _productViewCubit.state.userId!,
        ),
      );
    }
  }

  //buy layer

  void _scrollAction(ScrollNotification notification, BuildContext context) {
    if (notification is ScrollEndNotification) {
      _onVerticalSwipe(notification.dragDetails, context);
    }
  }

  void _onUserInput({
    required BuildContext context,
    required String fieldName,
    required String inputData,
  }) {
    _productViewCubit.setcartLoadingStateTrue();
    _productViewCubit.onUserInput(
      fieldName: fieldName,
      dataReceived: inputData,
    );
  }

  void _onCartIconPressed(BuildContext context) {
    context.go(AppRoutes.cart.path);
  }

  void _onAddCartItemPressed(BuildContext context) {
    if (_productViewCubit.state.isEveryFieldSatisfied) {
      CartItem cartItem = CartItem(
        id: '',
        userId: context.read<AuthBloc>().state.currentUser.id,
        userName:
            context.read<AuthBloc>().state.currentUser.email ??
            'AnonUser-id:${context.read<AuthBloc>().state.currentUser.id}',
        productId: _productViewCubit.state.product?.id ?? 'error',
        productName: _productViewCubit.state.product?.name ?? 'error',
        purchaseData: _productViewCubit.state.retrievedData ?? {},
        currency: 'rubDefault',
        checkoutPrice: _productViewCubit.state.precalculatedPrice,
        status: 'created',
        createdAt: DateTime.now(),
      );
      context.read<CartBloc>().add(
        CartEventAddCartItem(
          cartItem: cartItem,
          userId: context.read<AuthBloc>().state.currentUser.id,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: context.l10n.fillAllTheFields);
    }
  }

  void _onDeleteLastAddedItem(BuildContext context) {
    if (_productViewCubit.state.itemsInCart > 0 &&
        _productViewCubit.state.product != null) {
      context.read<CartBloc>().add(
        CartEventDeleteLastAddedProductCartItem(
          userId: context.read<AuthBloc>().state.currentUser.id,
          productId: _productViewCubit.state.product!.id,
        ),
      );
    }
  }

  void _onPageTransitionEnd() {
    _productViewCubit.setPageReadyTrue();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productViewCubit,
      child: Builder(
        builder: (context) {
          return MaterialProductView(
            tag: heroTag,
            onAdminProductPanelPressed: _onAdminProductPanelPressed,
            onBackButtonPressed: _onBackButtonPressed,
            onFavoritePressed: () => _onFavoritePressed(context),
            onVerticalSwipe: (p0) => _onVerticalSwipe(p0, context),
            onAddCartItemPressed: () => _onAddCartItemPressed(context),
            onAddFieldPressed: () => _onAddFieldPressed(context),
            onCartIconPressed: () => _onCartIconPressed(context),
            onDeleteLastAddedItem: () => _onDeleteLastAddedItem(context),
            onResetImageFieldPressed: () => _onResetImageFieldPressed(context),
            onUserInput: (p0, p1) =>
                _onUserInput(context: context, fieldName: p0, inputData: p1),
            onScrollAction: (p0) => _scrollAction(p0, context),
            onPageTransitionEnd: _onPageTransitionEnd,
          );
        },
      ),
    );
  }
}
