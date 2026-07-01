import 'dart:async';

import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  List<Product>? _userPreferences;
  List<Product>? _featuredProducts;
  late AuthUser currentUser;
  Completer<void>? _refreshCompleter;

  @override
  void initState() {
    currentUser = context.read<AuthBloc>().state.currentUser ?? appTempUser;
    super.initState();
  }

  void _reLoader(BuildContext context) {
    context.read<DatabaseBloc>().add(
      DatabaseEventInitialize(userId: currentUser.id),
    );
    //
    if (_refreshCompleter != null) {
      _refreshCompleter!.complete();
    }
  }

  Future<void> _openProductCardCallBack(
    BuildContext context,
    String productId,
    String additionalSuffix,
  ) async {
    await context.pushNamed(
      'card_view',
      pathParameters: {
        'productId': productId,
        'additionalSuffix': additionalSuffix,
      },
    );
    if (context.mounted) {
      context.read<CartBloc>().add(
        CartEventFetchUserCartItemAmount(
          userId: context.read<AuthBloc>().state.currentUser!.id,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: MediaQuery.paddingOf(context).top,
      onRefresh: () async {
        _refreshCompleter = Completer();
        _reLoader(context);
        await _refreshCompleter!.future;
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            SliverPadding(
              padding: EdgeInsetsGeometry.only(
                top: MediaQuery.paddingOf(context).top,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 24),
                child: Text(
                  'Featured',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: .w700,
                    color: context.appColorScheme.secondary,
                  ),
                ),
              ),
            ),
            BlocBuilder<DatabaseBloc, DatabaseState>(
              builder: (context, state) {
                final featuredProductsId =
                    context.read<DatabaseBloc>().state.featuredProducts ?? [];
                if (featuredProductsId.isNotEmpty &&
                    (state.products?.isNotEmpty ?? false)) {
                  _featuredProducts = [];
                  for (var productId in featuredProductsId) {
                    _featuredProducts!.add(
                      state.products!.firstWhere(
                        (product) => product.id == productId,
                      ),
                    );
                  }
                } else {
                  _featuredProducts = null;
                }
                return _featuredProducts != null
                    ? SliverList.builder(
                        itemCount: _featuredProducts!.length,
                        itemBuilder: (context, index) => ProductCard(
                          product: _featuredProducts![index],
                          additionalSuffix: 'featuredProduct',
                          openProductCardCallBack: _openProductCardCallBack,
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 177),
                          child: Text(''),
                        ),
                      );
              },
            ),
            BlocBuilder<DatabaseBloc, DatabaseState>(
              builder: (context, state) {
                final userPreferencesId =
                    context.read<DatabaseBloc>().state.userPreferences ?? [];

                return userPreferencesId.isNotEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, left: 24),
                          child: Text(
                            'Your Favorite',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: .w700,
                              color: context.appColorScheme.secondary,
                            ),
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'You favore nothing :(',
                              style: TextStyle(
                                color: context.appColorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
            BlocBuilder<DatabaseBloc, DatabaseState>(
              builder: (context, state) {
                final userPreferencesId =
                    context.read<DatabaseBloc>().state.userPreferences ?? [];
                if (userPreferencesId.isNotEmpty &&
                    (state.products?.isNotEmpty ?? false)) {
                  _userPreferences = [];
                  for (var productId in userPreferencesId) {
                    _userPreferences!.add(
                      state.products!.firstWhere(
                        (product) => product.id == productId,
                      ),
                    );
                  }
                } else {
                  _userPreferences = null;
                }
                return _userPreferences != null
                    ? SliverList.builder(
                        itemCount: _userPreferences!.length,
                        itemBuilder: (context, index) => ProductCard(
                          product: _userPreferences![index],
                          additionalSuffix: 'userPreferences',
                          openProductCardCallBack: _openProductCardCallBack,
                        ),
                      )
                    : SliverPadding(padding: EdgeInsetsGeometry.all(1));
              },
            ),
            SliverPadding(
              padding: EdgeInsetsGeometry.only(
                bottom: MediaQuery.paddingOf(context).bottom + 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
