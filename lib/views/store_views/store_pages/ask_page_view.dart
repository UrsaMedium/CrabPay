import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AskPageView extends StatelessWidget {
  const AskPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // final currentUser = context.read<AuthBloc>().state.currentUser;
    return context.read<AuthBloc>().state.currentUser.isAdmin
        ? Column(
            children: [
              SizedBox(height: MediaQuery.paddingOf(context).top),
              ElevatedButton(
                onPressed: () {
                  context.read<DatabaseBloc>().add(
                    DatabaseEventFetchAllProducts(),
                  );
                },
                child: Text('fetch data'),
              ),
              ElevatedButton(
                onPressed: () =>
                    context.push('/add_complete_product_product_view'),
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
                onPressed: () => context.push('/add_featured_product_view'),
                child: Text('Add Featured Product'),
              ),
            ],
          )
        : Padding(
            padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  final user = context.read<AuthBloc>().state.currentUser;
                  print('---');
                  print('id - ${user.id}');
                  print('email - ${user.email}');
                  print('ver - ${user.isEmailVerified}');
                  print('anon - ${user.isAnonymous}');
                  print('admin - ${user.isAdmin}');
                  print('---');
                },
                child: Text('Hey :)'),
              ),
            ),
          );
  }
}
