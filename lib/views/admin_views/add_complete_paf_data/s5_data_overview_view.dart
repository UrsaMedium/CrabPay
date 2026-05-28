import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_model.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DataOverviewView extends StatelessWidget {
  const DataOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppProduct? appProduct = context.read<AdminBloc>().state.appProduct;
    final List<AppProductField>? appProductFields = context
        .read<AdminBloc>()
        .state
        .appProductFields;
    final Map<List<String>, double>? priceFunction = context
        .read<AdminBloc>()
        .state
        .priceFunction;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(children: [Text(priceFunction.toString())]),
    );
  }
}
