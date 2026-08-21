import 'package:crabpay/core/app_services/app_lifecycle.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_bloc.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/chat_bloc/admin_chat_bloc.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/admin_inner_chat_handler.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_inner_database_handler.dart';
import 'package:crabpay/core/backend/connection_monitoring/inner_monitor/connection_monitor_cubit.dart';
import 'package:crabpay/core/backend/connection_monitoring/inner_monitor/inner_connection_monitor.dart';
import 'package:crabpay/core/backend/connection_monitoring/outer_monitor/connection_monitor_to_supabase_at_regred.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/inner_cart_handler.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/inner_chat_handler.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_bloc.dart';
import 'package:crabpay/core/backend/pyament_services/payment_service.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthInnerInterface>(
          create: (_) => getIt<AuthInnerInterface>(),
        ),
        RepositoryProvider<InnerChatHandler>(
          create: (_) => getIt<InnerChatHandler>(),
        ),
        RepositoryProvider<AdminInnerChatHandler>(
          create: (_) => getIt<AdminInnerChatHandler>(),
        ),
        RepositoryProvider<InnerDatabaseHandler>(
          create: (_) => getIt<InnerDatabaseHandler>(),
        ),
        RepositoryProvider<AdminInnerDatabaseHandler>(
          create: (_) => getIt<AdminInnerDatabaseHandler>(),
        ),
        RepositoryProvider<InnerCartHandler>(
          create: (_) => getIt<InnerCartHandler>(),
        ),
        RepositoryProvider<PaymentOuterHandler>(
          create: (_) => getIt<PaymentOuterHandler>(),
        ),
        RepositoryProvider<InnerConnectionMonitor>(
          create: (context) => ConnectionMonitorToSupabaseAtRegred(
            appLifecycleService: getIt<AppLifecycleService>(),
          ),
          dispose: (repo) => repo.dispose(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(context.read<AuthInnerInterface>())
                  ..add(const AuthEventInitialize()),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(
              chatHandler: context.read<InnerChatHandler>(),
              authInterface: context.read<AuthInnerInterface>(),
            ),
          ),
          BlocProvider<ChatBlocAdmin>(
            create: (context) => ChatBlocAdmin(
              chatHandlerAdmin: context.read<AdminInnerChatHandler>(),
              authInterface: context.read<AuthInnerInterface>(),
            ),
          ),
          BlocProvider<DatabaseBloc>(
            create: (context) => DatabaseBloc(
              databaseHandler: context.read<InnerDatabaseHandler>(),
              authInnerface: context.read<AuthInnerInterface>(),
            ),
          ),
          BlocProvider<DatabaseBlocAdmin>(
            create: (context) => DatabaseBlocAdmin(
              databaseHandlerAdmin: context.read<AdminInnerDatabaseHandler>(),
              authInnerface: context.read<AuthInnerInterface>(),
            ),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(
              cartHandler: context.read<InnerCartHandler>(),
              authInterface: context.read<AuthInnerInterface>(),
              appLifecycleService: getIt<AppLifecycleService>(),
            ),
          ),
          BlocProvider<PaymentBloc>(
            create: (context) =>
                PaymentBloc(context.read<PaymentOuterHandler>()),
          ),
          BlocProvider(create: (context) => GlobalGraphicBloc()),
          BlocProvider(
            create: (context) => ConnectionMonitorCubit(
              connectionMonitor: context.read<InnerConnectionMonitor>(),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
