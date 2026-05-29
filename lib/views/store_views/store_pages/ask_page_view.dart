import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_event.dart';
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
            context.read<DatabaseBloc>().add(DatabaseEventFetchAllProductAndFieldsData());
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
