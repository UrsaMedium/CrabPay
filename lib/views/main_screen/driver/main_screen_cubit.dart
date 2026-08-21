import 'dart:async';

import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class MainScreenState extends Equatable {
  final int page;
  final AppAuthUser? currentUser;
  final bool isLoggedIn;
  final bool isAdmin;
  final int userCartItemAmount;
  final bool isSyncingByNavBarTap;
  final GlobalKey profileIconButtonKey;
  final int amountOfPendingOrders;

  const MainScreenState({
    this.page = 0,
    this.currentUser,
    this.userCartItemAmount = 0,
    this.isLoggedIn = false,
    this.isAdmin = false,
    this.isSyncingByNavBarTap = false,
    required this.profileIconButtonKey,
    this.amountOfPendingOrders = 0,
  });

  MainScreenState copyWith({
    int? page,
    AppAuthUser? currentUser,
    int? userCartItemAmount,
    bool? isLoggedIn,
    bool? isAdmin,
    bool? isSyncingByNavBarTap,
    GlobalKey? profileIconButtonKey,
    int? amountOfPendingOrders,
  }) {
    return MainScreenState(
      page: page ?? this.page,
      currentUser: currentUser ?? this.currentUser,
      userCartItemAmount: userCartItemAmount ?? this.userCartItemAmount,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isAdmin: isAdmin ?? this.isAdmin,
      isSyncingByNavBarTap: isSyncingByNavBarTap ?? this.isSyncingByNavBarTap,
      profileIconButtonKey: profileIconButtonKey ?? this.profileIconButtonKey,
      amountOfPendingOrders:
          amountOfPendingOrders ?? this.amountOfPendingOrders,
    );
  }

  @override
  List<Object?> get props => [
    page,
    currentUser,
    userCartItemAmount,
    isLoggedIn,
    isAdmin,
    isSyncingByNavBarTap,
    amountOfPendingOrders,
  ];
}

class MainScreenCubit extends Cubit<MainScreenState> {
  final AuthBloc _authBloc;
  final CartBloc _cartBloc;
  late final StreamSubscription _authSubscription;
  late final StreamSubscription _cartSubscription;
  MainScreenCubit({
    required AuthBloc authBloc,
    required CartBloc cartBloc,
    required GlobalKey globalKey,
  }) : _authBloc = authBloc,
       _cartBloc = cartBloc,
       super(MainScreenState(profileIconButtonKey: globalKey)) {
    _authSubscription = _authBloc.stream.listen((authState) {
      final isLoggedIn =
          !(authState.currentUser.email == null ||
              authState.currentUser.isAnonymous);
      emit(
        state.copyWith(
          currentUser: authState.currentUser,
          isLoggedIn: isLoggedIn,
          isAdmin: authState.currentUser.isAdmin,
        ),
      );
    });
    _cartSubscription = _cartBloc.stream.listen((cartState) {
      if (cartState.states == CartStates.updatedUserCartItemCount) {
        emit(state.copyWith(userCartItemAmount: cartState.userCartItemAmount));
      }
      if (cartState.pendingOrdersState == PendingOrdersState.updated) {
        emit(
          state.copyWith(
            amountOfPendingOrders: cartState.pendingOrders?.length ?? 0,
          ),
        );
      }
    });
  }

  void onPageSwipe(int index) {
    if (state.page != index) {
      emit(state.copyWith(page: index));
    }
  }

  void setSyncByNavBarState(bool isInSync) {
    emit(state.copyWith(isSyncingByNavBarTap: isInSync));
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _cartSubscription.cancel();
    return super.close();
  }
}
