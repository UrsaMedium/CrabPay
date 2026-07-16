import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_bloc.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_event.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_state.dart';
import 'package:crabpay/core/local_storage/local_storage.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/cart_page/material_cart_page_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartPageDriver extends StatefulWidget {
  const CartPageDriver({super.key});

  @override
  State<CartPageDriver> createState() => _CartPageDriverState();
}

class _CartPageDriverState extends State<CartPageDriver> {
  late final AppLifecycleListener _appLifecycleListener;
  List<CartItem>? _cartItems;
  List<Product>? _products;

  @override
  void initState() {
    context.read<CartBloc>().add(
      CartEventFetchCartItems(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
    _appLifecycleListener = AppLifecycleListener(
      onHide: () => _onUserLeave(context: context),
      onResume: () => _onUserReturn(context: context),
    );
    _onUserReturn(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
  }

  void _onUserLeave({required BuildContext context}) {
    print('--- User has left the app');
    if (context.read<PaymentBloc>().state is PaymentStateListening) {
      final cartItemIds = _cartItems?.map((e) => e.id).toList() ?? [];
      AppLocalStorage.saveCartItemsOnPayment(cartItemIds);
    } else {
      AppLocalStorage.saveCartItemsOnPayment([]);
      AppLocalStorage.savePaymentLink('');
    }
    // _lifecycleListener.dispose();
  }

  void _onUserReturn({required BuildContext context}) {
    print('--- User has returned to the app');
    final cartItemIds = AppLocalStorage.getCartItemIdsOnPayment();
    if (cartItemIds != null) {
      context.read<PaymentBloc>().add(
        PaymentEventOnAppBackToLive(cartItemIds: cartItemIds),
      );
    }
  }

  // List<CartItem> _filterItemsToBuy({required List<CartItem> allCartItems}) {
  //   return allCartItems
  //       .where(
  //         (item) => !['paid', 'delivered', 'canceled'].contains(item.status),
  //       )
  //       .toList();
  // }

  double _countTotal() {
    return _cartItems?.fold(0, (sum, item) => sum! + item.checkoutPrice) ?? 0;
  }

  void _onACartItemDelete({
    required BuildContext context,
    required CartItem cartItem,
  }) {
    context.read<CartBloc>().add(
      CartEventDeleteCartItem(
        cartItem: cartItem,
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
    context.read<CartPageCubit>().setDeletingItem(cartItem);
  }

  void _onBuyPressed(BuildContext context, double total) {
    if (total != 0 || (_cartItems?.isNotEmpty ?? false)) {
      context.read<PaymentBloc>().add(
        PaymentEventPay(provider: 'YooPay', cartItems: _cartItems!),
      );
    } else {
      return;
    }
  }

  void _onPaymentLinkPressed(BuildContext context) {
    final paymentLink = AppLocalStorage.getPaymentLink();
    if (paymentLink != null) {
      context.read<PaymentBloc>().add(
        PaymentEventReturnToProvider(link: paymentLink),
      );
    } else {
      Fluttertoast.showToast(msg: 'Link is lost');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartPageCubit(),
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          final userId = context.read<AuthBloc>().state.currentUser.id;

          if (state is PaymentStateUserAtProvider && _cartItems != null) {
            context.read<PaymentBloc>().add(
              PaymentEventListen(cartItems: _cartItems!),
            );
          } else if (state is PaymentStateFailure ||
              state is PaymentStatePaid) {
            context.read<PaymentBloc>().add(PaymentEventSilence());
            context.read<CartBloc>().add(
              CartEventFetchCartItems(userId: userId),
            );
          }
        },
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, paymentState) {
            final bool isPaymentStateActive =
                !(paymentState is PaymentStateFailure ||
                    paymentState is PaymentStatePaid ||
                    paymentState is PaymentStateSilence);

            _products = context.select<DatabaseBloc, List<Product>>(
              (bloc) => bloc.state.products ?? [],
            );
            // _cartItems = _filterItemsToBuy(
            //   allCartItems: context.select<CartBloc, List<CartItem>>(
            //     (bloc) => bloc.state.cartItemsToBuy ?? [],
            //   ),
            // );
            _cartItems = context.select<CartBloc, List<CartItem>>(
              (bloc) => bloc.state.cartItemsToBuy ?? [],
            );

            final total = _countTotal();

            if (defaultTargetPlatform == TargetPlatform.iOS) {
              // TODO: Cupertino
            }

            final deletingItemId =
                context.select<CartPageCubit, CartItem?>(
                  (cubit) => cubit.state,
                ) ??
                CartItem.intial();

            return MaterialCartPageView(
              cartItems: _cartItems ?? [],
              isPaymentStateActive: isPaymentStateActive,
              total: total,
              products: _products ?? [],
              onACartItemDelete: (CartItem cartItemToDelete) =>
                  _onACartItemDelete(
                    cartItem: cartItemToDelete,
                    context: context,
                  ),
              theBeingDeletedCartItem: deletingItemId,
              onBuyPressed: () => _onBuyPressed(context, total),
              onPaymentLinkPressed: () => _onPaymentLinkPressed(context),
            );
          },
        ),
      ),
    );
  }
}

class CartPageCubit extends Cubit<CartItem?> {
  CartPageCubit() : super(null);

  void setDeletingItem(CartItem? itemToDelete) => emit(itemToDelete);
}
