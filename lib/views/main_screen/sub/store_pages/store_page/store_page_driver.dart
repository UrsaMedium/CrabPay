import 'dart:async';

import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/store_page/store_page_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorePageDriver extends StatefulWidget {
  const StorePageDriver({super.key});

  @override
  State<StorePageDriver> createState() => _StorePageDriverState();
}

class _StorePageDriverState extends State<StorePageDriver> {
  Completer<void>? _refreshCompleter;
  List<Product>? products;
  List<Product>? filterdProductList;

  Future<void> _reFresher(BuildContext context) async {
    _refreshCompleter = Completer();
    context.read<DatabaseBloc>().add(DatabaseEventFetchAllProducts());
    await _refreshCompleter!.future;
  }

  void _onSearchSubmitedCallBack(List<Product> filteredList) {
    setState(() {
      filterdProductList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DatabaseBloc, DatabaseState>(
      listenWhen: (previous, current) =>
          previous.states == DatabaseStates.dbLoading &&
          current.states != DatabaseStates.dbLoading,
      listener: (context, state) {
        if (!(_refreshCompleter?.isCompleted ?? true)) {
          _refreshCompleter!.complete();
        }
      },
      child: BlocProvider(
        create: (_) => StorePageCubit(),
        child: BlocBuilder<StorePageCubit, StorePageState>(
          builder: (context, viewState) {
            products = context.select<DatabaseBloc, List<Product>>(
              (bloc) => bloc.state.products ?? [],
            );

            if (defaultTargetPlatform == TargetPlatform.iOS) {
              //TODO cupertino
            }

            return MaterialStorePageView(
              onOpenProductCardCallBack: openProductCardCallBack,
              products: products ?? [],
              reFresher: () => _reFresher(context),
              filterdProductList: filterdProductList ?? [],
              onSearchSubmitedCallBack: _onSearchSubmitedCallBack,
            );
          },
        ),
      ),
    );
  }
}

class StorePageState {
  final List<Product>? filterdProductList;

  StorePageState({this.filterdProductList});

  StorePageState copyWith({List<Product>? filterdProductList}) {
    return StorePageState(
      filterdProductList: filterdProductList ?? this.filterdProductList,
    );
  }
}

class StorePageCubit extends Cubit<StorePageState> {
  StorePageCubit() : super(StorePageState());
}
