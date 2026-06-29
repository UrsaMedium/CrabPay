import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/widgets/product_card.dart';
import 'package:crabpay/core/widgets/store_search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StorePageView extends StatefulWidget {
  const StorePageView({super.key});

  @override
  State<StorePageView> createState() => StorePageViewState();
}

class StorePageViewState extends State<StorePageView> {
  LocalHistoryEntry? _historyEntryToControllTheBackCall;
  bool _doAbsorb = false;
  @override
  void initState() {
    if (context.read<DatabaseBloc>().state.products == null) {
      _dataFetching(context);
    }
    super.initState();
  }

  Future<void> _dataFetching(BuildContext context) async {
    if (context.read<DatabaseBloc>().state.products == null) {
      context.read<DatabaseBloc>().add(DatabaseEventFetchAllProducts());
      context.read<DatabaseBloc>().add(DatabaseEventFetchAllCurrencies());
    } else {
      if (context.read<DatabaseBloc>().state.products!.isEmpty) {
        context.read<DatabaseBloc>().add(DatabaseEventFetchAllProducts());
        context.read<DatabaseBloc>().add(DatabaseEventFetchAllCurrencies());
      }
    }
    final currentUser =
        context.read<AuthBloc>().state.currentUser ?? appTempUser;
    context.read<CartBloc>().add(
      CartEventFetchUserCartItemAmount(userId: currentUser.id),
    );
  }

  void isSearchFocusedCallBack(bool isSearchFocused) {
    _doAbsorb = isSearchFocused;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            edgeOffset: MediaQuery.paddingOf(context).top,
            onRefresh: () async {
              context.read<DatabaseBloc>().add(
                DatabaseEventFetchAllCurrencies(),
              );
              context.read<DatabaseBloc>().add(DatabaseEventFetchAllProducts());
              await context.read<DatabaseBloc>().stream.firstWhere(
                (state) =>
                    (state.states == DatabaseStates.productsFetched ||
                    state.states == DatabaseStates.productsNotFetched),
              );
            },
            child: BlocBuilder<DatabaseBloc, DatabaseState>(
              buildWhen: (previous, current) =>
                  (previous.products != current.products),
              builder: (context, state) {
                final products = state.products ?? [];
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: .only(
                    top: MediaQuery.paddingOf(context).top,
                    bottom: MediaQuery.paddingOf(context).bottom,
                  ),
                  itemExtent: 224,
                  itemCount: products.length,
                  itemBuilder: (context, index) => AbsorbPointer(
                    absorbing: _doAbsorb,
                    child: ProductCard(product: products[index]),
                  ),
                );
              },
            ),
          ),
          StoreSearchBarState(
            isSearchedFocusedCallBack: isSearchFocusedCallBack,
          ),
        ],
      ),
    );
  }
}
