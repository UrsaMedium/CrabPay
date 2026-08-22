import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/_sub/product_view/driver/product_view_driver.dart';
import 'package:crabpay/views/main_screen/_sub/orders_view/driver/orders_driver.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> otherRoutes = [
  GoRoute(
    path: AppRoutes.orders.path,
    name: AppRoutes.orders.name,
    builder: (context, state) => const OrdersViewDriver(),
  ),
  GoRoute(
    path: AppRoutes.productCard.path,
    name: AppRoutes.productCard.name,
    pageBuilder: (context, state) {
      final productId = state.pathParameters['productId'] ?? '0';
      final tag = state.pathParameters['tag'] ?? '0';

      return CustomTransitionPage(
        key: state.pageKey,
        child: ProductViewDriver(productId: productId, tag: tag),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
      );
    },
  ),
];
