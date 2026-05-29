import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/paf_bloc/paf_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/paf_bloc/paf_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AskPageView extends StatelessWidget {
  const AskPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<PafBloc>().add(PafEventFetchAllPAPData());
          },
          child: Text('fetch data'),
        ),
        ElevatedButton(
          onPressed: () => context.go('/add_complete_product_product_view'),
          child: Text('Add complete product'),
        ),
      ],
    );
  }
}
