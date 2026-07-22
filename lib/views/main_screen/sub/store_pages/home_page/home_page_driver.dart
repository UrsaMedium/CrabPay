import 'dart:async';

import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/home_page/material_home_page_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageDriver extends StatefulWidget {
  const HomePageDriver({super.key});

  @override
  State<HomePageDriver> createState() => _HomePageDriverState();
}

class _HomePageDriverState extends State<HomePageDriver> {
  Completer<void>? _refreshCompleter;

  Future<void> _reFresher(BuildContext context) async {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'HomePageDriver _reFresher',
    );
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
    return BlocListener<DatabaseBloc, DatabaseState>(
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
          final featuredProducts = context.select<DatabaseBloc, List<Product>>(
            (bloc) => bloc.state.featuredProducts ?? [],
          );
          final userPrefernces = context.select<DatabaseBloc, List<Product>>(
            (bloc) => bloc.state.userPreferences ?? [],
          );

          if (defaultTargetPlatform == TargetPlatform.iOS) {
            //TODO cupertino
          }

          return MaterialHomePageView(
            onOpenProductCardCallBack: openProductCardCallBack,
            reFresher: () => _reFresher(context),
            featuredProducts: featuredProducts,
            userPreferences: userPrefernces,
          );
        },
      ),
    );
  }
}
