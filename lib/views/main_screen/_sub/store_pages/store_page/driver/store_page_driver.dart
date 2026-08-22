import 'dart:async';
import 'dart:developer' as developer;
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/driver/store_page_cubit.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/view/material/material_store_page.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/view/material/material_store_page_og.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StorePageDriver extends StatefulWidget {
  const StorePageDriver({super.key});

  @override
  State<StorePageDriver> createState() => _StorePageDriverState();
}

class _StorePageDriverState extends State<StorePageDriver>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final StorePageCubit _storePageCubit;
  Completer<void>? _refreshCompleter;

  @override
  void initState() {
    _storePageCubit = StorePageCubit(dbBLoc: context.read<DatabaseBloc>());
    super.initState();
  }

  Future<void> _reFresher(BuildContext context) async {
    _refreshCompleter = Completer();
    context.read<DatabaseBloc>().add(DatabaseEventFetchAllProducts());
    await _refreshCompleter!.future;
  }

  void _onSearchSubmitedCallBack(List<Product> filteredList) {
    _storePageCubit.setFilteredList(filteredList);
  }

  void _onCategoryViewOpen(BuildContext context, String tag) {
    developer.log('1');
    context.goNamed(
      AppRoutes.storeCategoryView.name,
      pathParameters: {'tag': tag},
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<DatabaseBloc, DatabaseState>(
      listenWhen: (previous, current) =>
          previous.states == DatabaseStates.dbLoading &&
          current.states != DatabaseStates.dbLoading,
      listener: (context, state) {
        if (!(_refreshCompleter?.isCompleted ?? true)) {
          _refreshCompleter!.complete();
        }
      },
      child: BlocProvider.value(
        value: _storePageCubit,
        child: Builder(
          builder: (context) {
            final newPage = 2 == 2;
            if (newPage) {
              return MaterialStorePage(
                reFresher: () => _reFresher(context),
                onCategoryViewOpen: (tag) => _onCategoryViewOpen(context, tag),
              );
            }

            return MaterialStorePageOG(
              reFresher: () => _reFresher(context),
              onSearchSubmitedCallBack: _onSearchSubmitedCallBack,
            );
          },
        ),
      ),
    );
  }
}
