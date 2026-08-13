import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/sub/card_view/buy_bottom_sheet/buy_bottom_sheet_driver.dart';
import 'package:crabpay/views/main_screen/sub/card_view/product_view/driver/cubit.dart';
import 'package:crabpay/views/main_screen/sub/card_view/product_view/view/material/material_product_view_ground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ProductViewDriver extends StatefulWidget {
  static const routeName = 'card_view';
  final String productId; //also tag identoty
  final String additionalSuffix; //tag identoty
  final String index; //tag identoty
  const ProductViewDriver({
    super.key,
    required this.productId,
    required this.additionalSuffix,
    required this.index,
  });

  @override
  State<ProductViewDriver> createState() => _ProductViewDriverState();
}

class _ProductViewDriverState extends State<ProductViewDriver> {
  late final ProductViewCubit _productViewCubit;
  late final String heroTag;

  @override
  void initState() {
    heroTag =
        'card-hero-${widget.productId}-${widget.additionalSuffix}-${widget.index}';
    final theProduct = context
        .read<DatabaseBloc>()
        .state
        .products
        ?.where((aProduct) => aProduct.id == widget.productId)
        .firstOrNull;

    final productFields =
        context
            .read<DatabaseBloc>()
            .state
            .cachedProductFields?[widget.productId] ??
        [];

    if (theProduct == null) {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'ProductViewDriver product not found',
        data: {'productId': widget.productId},
      );
      context.go(AppRoutes.home.path);
    }
    _productViewCubit = ProductViewCubit(
      databaseBloc: context.read<DatabaseBloc>(),
      isAdmin: context.read<AuthBloc>().state.currentUser.isAdmin,
      isAnonymous: context.read<AuthBloc>().state.currentUser.isAnonymous,
      userId: context.read<AuthBloc>().state.currentUser.id,
      product: theProduct!,
      productFields: productFields,
    );
    super.initState();
  }

  void onVerticalSwipe(DragEndDetails details) {
    if (details.primaryVelocity! < -300) {
      _productViewCubit.setLayer(true);
    } else if (details.primaryVelocity! > 300) {
      _productViewCubit.setLayer(false);
    }
  }

  void onBackButtonPressed() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'ProductViewDriver onBackButtonPressed',
    );
    if (GoRouter.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home.path);
    }
  }

  void onAdminProductPanelPressed() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'ProductViewDriver onAdminProductPanelPressed',
    );
    context.pushNamed(
      AppRoutes.updateProduct.name,
      pathParameters: {'productId': widget.productId},
    );
  }

  void onFavoritePressed(BuildContext context) {
    _productViewCubit.setFavoriteLoadingStateTrue();
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'ProductViewDriver onFavoritePressed',
      data: {
        'isAnonymous': _productViewCubit.state.isAnonymous,
        'isBeingLoaded': _productViewCubit.state.isLoading,
        'isFavorite': _productViewCubit.state.isFavorite,
      },
    );
    if (_productViewCubit.state.isAnonymous) {
      Fluttertoast.showToast(msg: 'Sign In');
      return;
    }
    if (_productViewCubit.state.isLoading) {
      Fluttertoast.showToast(msg: 'Please, wait');
      return;
    }
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

  Future<void> onBuyBottomSheetCalled() async {
    if (_productViewCubit.state.productFields != null) {
      await showModalBottomSheet(
        showDragHandle: false,
        useSafeArea: false,
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow
            .withValues(alpha: context.highGraphics ? .5 : .95),
        builder: (_) {
          return BuyBottomSheetDriver(
            product: _productViewCubit.state.product!,
            productFields: _productViewCubit.state.productFields!,
          );
        },
      );
    } else {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message:
            'ProductViewDriver onBuyBottomSheetCalled productFields is null',
        data: {
          'productFields': _productViewCubit.state.productFields,
          'productId': widget.productId,
        },
      );
      Fluttertoast.showToast(msg: 'No Fields! Error');
      context.read<DatabaseBloc>().add(
        DatabaseEventFetchProductFields(productId: widget.productId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        getIt<InnerLoggerHandler>().logBreadcrumb(
          message: 'ProductViewDriver onPopInvokedWithResult',
          data: {'didPop': didPop, 'result': result},
        );
        if (didPop) {
          return;
        }
        !Navigator.of(context).canPop()
            ? context.go(AppRoutes.home.path)
            : context.pop();
      },
      child: BlocProvider.value(
        value: _productViewCubit,
        child: MaterialProductView(
          tag: heroTag,
          onAdminProductPanelPressed: onAdminProductPanelPressed,
          onBackButtonPressed: onBackButtonPressed,
          onBuyBottomSheetCalled: onBuyBottomSheetCalled,
          onFavoritePressed: () => onFavoritePressed(context),
          onVerticalSwipe: (p0) => onVerticalSwipe(p0),
        ),
      ),
    );
  }
}
