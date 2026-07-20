import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';

import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/local_storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

extension ContextExtensions on BuildContext {
  ColorScheme get appColorScheme => Theme.of(this).colorScheme;
}

const double cornerRadius = 24;

//local storage
final AppAuthUser appTempUser = AppLocalStorage.tempUser;

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
  print('pushed $productId + $additionalSuffix + $index');
  //data prefetching
  context.read<DatabaseBloc>().add(
    DatabaseEventFetchProductFields(productId: productId),
  );
  // final currentUser = context.read<AuthBloc>().state.currentUser ?? appTempUser;
  context.read<CartBloc>().add(
    CartEventFetchProductCartItemAmount(
      userId: context.read<AuthBloc>().state.currentUser.id,
      productId: productId,
    ),
  );
  //
  await context.pushNamed(
    'card_view',
    pathParameters: {
      'productId': productId,
      'additionalSuffix': additionalSuffix,
      'index': '$index',
    },
  );
  // refreshing cart counter
  if (context.mounted) {
    context.read<CartBloc>().add(
      CartEventFetchUserCartItemAmount(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
  }
}

class CustomFasterPageScrollPhysics extends PageScrollPhysics {
  const CustomFasterPageScrollPhysics({super.parent});

  @override
  CustomFasterPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomFasterPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 1, stiffness: 500, damping: 40);

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset * 3);
  }

  @override
  Tolerance get tolerance => const Tolerance(velocity: 10.0, distance: 1e-3);
}
