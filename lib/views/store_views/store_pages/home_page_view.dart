import 'dart:async';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  List<Product>? _userPreferences;
  List<Product>? _featuredProducts;
  // late AuthUser currentUser;
  Completer<void>? _refreshCompleter;

  @override
  void initState() {
    super.initState();
  }

  void _reLoader(BuildContext context) {
    context.read<DatabaseBloc>().add(
      DatabaseEventInitialize(
        currentUser: context.read<AuthBloc>().state.currentUser,
      ),
    );
    //
    if (_refreshCompleter != null) {
      _refreshCompleter!.complete();
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
              child: Align(
                alignment: .centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 8, bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: context.appColorScheme.outline),
                    ),
                    child: Text(
                      'Featured',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: .w700,
                        color: context.appColorScheme.onPrimaryContainer,
                      ),
                    ),
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
                          openProductCardCallBack: openProductCardCallBack,
                          index: '$index',
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
                        child: Align(
                          alignment: .centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              bottom: 8,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: context.appColorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: context.appColorScheme.outline,
                                ),
                              ),
                              child: Text(
                                'Favorite',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: .w700,
                                  color:
                                      context.appColorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: context.appColorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: context.appColorScheme.outline,
                                ),
                              ),
                              child: Text(
                                'You Favore Nothing :(',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: .w700,
                                  color: context.appColorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
            BlocBuilder<DatabaseBloc, DatabaseState>(
              builder: (context, state) {
                final userpreferencesProductId =
                    context.read<DatabaseBloc>().state.userPreferences ?? [];
                if (userpreferencesProductId.isNotEmpty &&
                    (state.products?.isNotEmpty ?? false)) {
                  _userPreferences = [];
                  for (var productId in userpreferencesProductId) {
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
                          openProductCardCallBack: openProductCardCallBack,
                          index: '$index',
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
