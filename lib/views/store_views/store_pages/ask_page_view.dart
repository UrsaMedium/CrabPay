import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AskPageView extends StatelessWidget {
  const AskPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.paddingOf(context).top),
        ElevatedButton(
          onPressed: () {
            context.read<DatabaseBloc>().add(DatabaseEventFetchAllProducts());
          },
          child: Text('fetch data'),
        ),
        ElevatedButton(
          onPressed: () => context.push('/add_complete_product_product_view'),
          child: Text('Add complete product'),
        ),
        ElevatedButton(
          onPressed: () => context.push('/deleting_view'),
          child: Text('Delete instances from DB'),
        ),
        ElevatedButton(
          onPressed: () => context.push('/product_field_update_view'),
          child: Text('Update Product Field'),
        ),
        ElevatedButton(
          onPressed: () => context.push('/product_update_view'),
          child: Text('Update a Product'),
        ),
      ],
    );
  }
}
