import 'dart:developer' as developer;
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final getIt = GetIt.instance;

extension DynamicDataParsing on dynamic {
  DateTime? toLocalDate() {
    if (this == null || this is! String) return null;

    final String dateString = this as String;
    if (dateString.isEmpty) return null;

    try {
      return DateTime.parse(dateString).toLocal();
    } catch (e) {
      return null;
    }
  }
}

typedef OnOpenProductCardCallBack =
    Future<void> Function({
      required BuildContext context,
      required String productId,
      required String additionalSuffix,
      required int index,
    });

Future<void> openProductCardCallBack({
  required BuildContext context,
  required String productId,
  required String additionalSuffix,
  required int index,
}) async {
  developer.log('pushed $productId + $additionalSuffix + $index');
  if (context
          .read<DatabaseBloc>()
          .state
          .cachedProductFields?[productId]
          ?.isEmpty ??
      true) {
    context.read<DatabaseBloc>().add(
      DatabaseEventFetchProductFields(productId: productId),
    );
  }
  context.read<CartBloc>().add(
    CartEventFetchProductCartItemAmount(
      userId: context.read<AuthBloc>().state.currentUser.id,
      productId: productId,
    ),
  );
  //
  await context.pushNamed(
    AppRoutes.productCard.name,
    pathParameters: {
      'productId': productId,
      'additionalSuffix': additionalSuffix,
      'index': '$index',
    },
  );
  if (context.mounted) {
    context.read<DatabaseBloc>().add(
      DatabaseEventFetchUserPreferences(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
  }
}
