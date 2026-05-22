import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PriceSpaceFillView extends StatefulWidget {
  const PriceSpaceFillView({super.key});

  @override
  State<PriceSpaceFillView> createState() => _PriceSpaceFillViewState();
}

class _PriceSpaceFillViewState extends State<PriceSpaceFillView> {
  late final Map<AppProductField, bool>? _priceDimentions;
  final List<String> _currencies = ['RUB', 'USD'];

  @override
  void didChangeDependencies() {
    _priceDimentions = context.read<AdminBloc>().state.priceDimentions;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomScrollView(
              shrinkWrap: true,
              slivers: [
                // SliverList.builder(itemBuilder: itemBuilder)
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: .end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (GoRouter.of(context).canPop()) {
                          context.pop();
                        }
                      },
                      child: Text('Back'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // context.go(
                        //   '/add_complete_product_product_view/add_product_fields_view/price_dimentions_maping_view/price_space_fill_view',
                        // );
                      },
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
