import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/logger/logger_outer_handler/outer_logger_handler.dart';
import 'package:crabpay/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminToolsView extends StatefulWidget {
  const AdminToolsView({super.key});

  @override
  State<AdminToolsView> createState() => _AdminToolsViewState();
}

class _AdminToolsViewState extends State<AdminToolsView> {
  AppAuthUser? user;
  @override
  Widget build(BuildContext context) {
    // final currentUser = context.read<AuthBloc>().state.currentUser;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        getIt<InnerLoggerHandler>().logBreadcrumb(
          message:
              'AdminToolsView back button pressed, navigating to /ask or popping the current route',
          data: {'didPop': didPop, 'result': result},
        );
        if (didPop) return;
        !Navigator.of(context).canPop() ? context.go('/ask') : context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              getIt<OuterLoggerHandler>().logBreadcrumb(
                message: 'AdminToolsView onBackButtonPressed',
              );
              if (context.canPop()) {
                context.pop();
              }
            },
            icon: Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.paddingOf(context).top),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      getIt<OuterLoggerHandler>().logBreadcrumb(
                        message: 'AdminToolsView fetch data button pressed',
                      );
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
                    onPressed: () => context.push('/add_featured_product_view'),
                    child: Text('Add Featured Product'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.push('/admin_tools_view/choose_thread_view'),
                    child: Text('Answer to users'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final loggerService = OuterLoggerHandler();
                      loggerService.logBreadcrumb(
                        message: 'User tapped the test crash button',
                        category: 'test',
                      );

                      throw Exception('GlitchTip Integration Test Crash!');
                    },
                    child: Text('Test logger'),
                  ),
                ],
              ),
              Column(
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
                    'Id: ${user?.id}\nemail: ${user?.email}\nver: ${user?.isEmailVerified}\nanon: ${user?.isAnonymous}\nadmin: ${user?.isAdmin}\nlimbo: ${user?.isLimbo}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
