import 'package:crabpay/core/backend/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/postgresql_server/db_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AskPageView extends StatefulWidget {
  const AskPageView({super.key});

  @override
  State<AskPageView> createState() => _AskPageViewState();
}

class _AskPageViewState extends State<AskPageView> {
  AuthUser? user;
  @override
  Widget build(BuildContext context) {
    // final currentUser = context.read<AuthBloc>().state.currentUser;
    return Column(
      children: [
        SizedBox(height: MediaQuery.paddingOf(context).top),
        ElevatedButton(
          onPressed: () {
            // final createTables = PostgreSQLSchema();
            // createTables.creeateTable('');
          },
          child: Text('test db'),
        ),
        !context.read<AuthBloc>().state.currentUser.isAdmin
            ? Column(
                children: [
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
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.paddingOf(context).top,
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          user = context.read<AuthBloc>().state.currentUser;
                          setState(() {});
                        },
                        child: Text('Hey :)'),
                      ),
                    ),
                  ),
                  Text(
                    'Id: ${user?.id}\nemail: ${user?.email}\nver: ${user?.isEmailVerified}\nanon: ${user?.isAnonymous}\nadmin: ${user?.isAdmin}',
                  ),
                ],
              ),
      ],
    );
  }
}
