import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/sub/card_view/product_view/product_view_driver.dart';
import 'package:crabpay/views/main_screen/sub/purchases_view/purchases_drive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> otherRoutes = [
  GoRoute(
    path: AppRoutes.purchases.path,
    name: AppRoutes.purchases.name,
    builder: (context, state) => const PurchasesViewDriver(),
  ),
  GoRoute(
    path: AppRoutes.productCard.path,
    name: AppRoutes.productCard.name,
    pageBuilder: (context, state) {
      final productId = state.pathParameters['productId'] ?? '0';
      final suffix = state.pathParameters['additionalSuffix'] ?? '0';
      final index = state.pathParameters['index'] ?? '0';

      return CustomTransitionPage(
        key: state.pageKey,
        child: ProductViewDriver(
          productId: productId,
          additionalSuffix: suffix,
          index: index,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
      );
    },
  ),
];
