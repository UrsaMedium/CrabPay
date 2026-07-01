import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_controller.dart'
    show DatabaseDataHandler;
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/local_storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

DatabaseDataHandler dbCache = DatabaseDataHandler();

extension ContextExtensions on BuildContext {
  ColorScheme get appColorScheme => Theme.of(this).colorScheme;
}

//local storage
AuthUser appTempUser = LocalStorage.tempUser;

//loading
final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();
OverlayEntry? _overlayEntry;

void showLoading(BuildContext context) {
  _overlayEntry = OverlayEntry(
    builder: (context) => Container(
      color: context.appColorScheme.onPrimary,
      child: const Center(child: CircularProgressIndicator()),
    ),
  );
  Overlay.of(context).insert(_overlayEntry!);
}

void hideLoading() {
  _overlayEntry?.remove();
  _overlayEntry = null;
}

void showScnackBarMessege(BuildContext context, String messege) {
  // ignore: avoid_print
  print(
    '${messege}_____________________________________________________________________________________________',
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(messege),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 200,
        left: 10,
        right: 10,
      ),
    ),
  );
}

Future<void> openProductCardCallBack(
  BuildContext context,
  String productId,
  String additionalSuffix,
  String index,
) async {
  print('pushed $productId + $additionalSuffix');
  //data prefetching
  context.read<DatabaseBloc>().add(
    DatabaseEventFetchProductFields(productId: productId),
  );
  final currentUser = context.read<AuthBloc>().state.currentUser ?? appTempUser;
  context.read<CartBloc>().add(
    CartEventFetchProductCartItemAmount(
      userId: currentUser.id,
      productId: productId,
    ),
  );
  //
  await context.pushNamed(
    'card_view',
    pathParameters: {
      'productId': productId,
      'additionalSuffix': additionalSuffix,
      'index': index,
    },
  );
  // refreshing cart counter
  if (context.mounted) {
    context.read<CartBloc>().add(
      CartEventFetchUserCartItemAmount(userId: currentUser.id),
    );
  }
}
