import 'dart:async';

import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/home_page/driver/home_page_cubit.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/home_page/view/material/material_home_page_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageDriver extends StatefulWidget {
  const HomePageDriver({super.key});

  @override
  State<HomePageDriver> createState() => _HomePageDriverState();
}

class _HomePageDriverState extends State<HomePageDriver>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final HomePageCubit _homePageCubit;
  Completer<void>? _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _homePageCubit = HomePageCubit(dbBloc: context.read<DatabaseBloc>());
  }

  @override
  void didChangeDependencies() {
    _homePageCubit.setLayouts(
      containerHalfWidth: MediaQuery.widthOf(context) / 2 - 28,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _homePageCubit.close();
    super.dispose();
  }

  Future<void> _onOpenProductCardCallBack({
    required BuildContext context,
    required String productId,
    required String additionalSuffix,
    required int index,
  }) async {
    await openProductCardCallBack(
      additionalSuffix: additionalSuffix,
      context: context,
      index: index,
      productId: productId,
    );
    // if (mounted) {
    //   _homePageCubit._syncDabaseData();
    // }
  }

  Future<void> _reFresher(BuildContext context) async {
    _refreshCompleter = Completer();
    context.read<DatabaseBloc>().add(
      DatabaseEventInitialize(
        currentUser: context.read<AuthBloc>().state.currentUser,
      ),
    );
    await _refreshCompleter!.future;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _homePageCubit,
      child: BlocListener<DatabaseBloc, DatabaseState>(
        listenWhen: (previous, current) =>
            previous.states == DatabaseStates.dbLoading &&
            current.states != DatabaseStates.dbLoading,
        listener: (context, dbState) {
          if (!(_refreshCompleter?.isCompleted ?? true)) {
            _refreshCompleter!.complete();
          }
        },
        child: Builder(
          builder: (context) {
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              // cupertino
            }

            return MaterialHomePageView(
              onOpenProductCardCallBack:
                  ({
                    required additionalSuffix,
                    required index,
                    required productId,
                  }) => _onOpenProductCardCallBack(
                    additionalSuffix: additionalSuffix,
                    context: context,
                    index: index,
                    productId: productId,
                  ),
              reFresher: () => _reFresher(context),
            );
          },
        ),
      ),
    );
  }
}
