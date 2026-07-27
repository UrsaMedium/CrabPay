import 'package:crabpay/core/backend/admin/admin_database/admin_outer_database_handler/admin_outer_database_handler_with_supabase.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_bloc.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/chat_bloc/admin_chat_bloc.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_outer_circle/admin_outer_chat_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_outer_circle/outer_database_handler_with_supabase.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_outer_circle/outer_cart_handler_with_supabase.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_outer_circle/supabase_outer_auth_interface.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/inner_chat_handler.dart';
import 'package:crabpay/core/backend/chat_service/chat_outer_circle/outer_chat_handler.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/logger/logger_outer_handler/outer_logger_handler.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_bloc.dart';
import 'package:crabpay/core/backend/pyament_services/payment_service.dart';
import 'package:crabpay/views/app_routes/main_screen_routes.dart';
import 'package:crabpay/core/backend/supabase/supabase_conf.dart';
import 'package:crabpay/views/root_view.dart';
import 'package:crabpay/views/widgets/global_loading_screen.dart';
import 'package:crabpay/core/local_storage/local_storage.dart';
import 'package:crabpay/views/app_routes/admin_routes.dart';
import 'package:crabpay/views/app_routes/other_routes.dart';
import 'package:crabpay/views/app_routes/auth_routes.dart';
import 'package:crabpay/views/app_routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setupDependencies() {
  getIt.registerSingleton<InnerLoggerHandler>(OuterLoggerHandler());
}

Future<void> main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseAccessConf['url']!,
    publishableKey: supabaseAccessConf['publishableKey']!,
  );
  await AppLocalStorage.init();
  setupDependencies();
  await getIt<InnerLoggerHandler>().init();

  // FlutterError.onError = (FlutterErrorDetails details) {
  //   getIt<InnerLoggerHandler>().recordException(
  //     error: details,
  //     stackTrace: details.stack ?? StackTrace.empty,
  //   );
  // };

  // PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
  //   getIt<InnerLoggerHandler>().recordException(
  //     error: error,
  //     stackTrace: stack,
  //   );
  //   return true;
  // };

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthInnerInterface>(
          create: (context) => SupabaseOuterAuthInterface(),
        ),
        RepositoryProvider<InnerChatHandler>(
          create: (context) => OuterChatHandlerWithSupabase(),
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
              chatHandler: OuterChatHandlerWithSupabase(),
              authInterface: context.read<AuthInnerInterface>(),
            ),
          ),
          BlocProvider<ChatBlocAdmin>(
            create: (context) => ChatBlocAdmin(
              chatHandlerAdmin: AdminOuterChatHandlerWithSupabase(),
              authInterface: context.read<AuthInnerInterface>(),
            ),
          ),
          BlocProvider<DatabaseBloc>(
            create: (context) => DatabaseBloc(
              databaseHandler: OuterDatabaseHandlerWithSupabase(),
              authInnerface: context.read<AuthInnerInterface>(),
            ),
          ),
          BlocProvider<DatabaseBlocAdmin>(
            create: (context) => DatabaseBlocAdmin(
              databaseHandlerAdmin: AdminOuterDatabaseHandlerWithSupabase(),
              authInnerface: context.read<AuthInnerInterface>(),
            ),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(
              cartHandler: OuterCartHandlerWithSupabase(),
              authInterface: context.read<AuthInnerInterface>(),
            ),
          ),
          BlocProvider<PaymentBloc>(
            create: (context) => PaymentBloc(PaymentOuterHandler()),
          ),
        ],
        child: const CrabPayApp(),
      ),
    ),
  );
}

final GoRouter _appRouter = GoRouter(
  initialLocation: AppRoutes.root.path,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.root.path,
      builder: (context, state) => RootView(),
      routes: [
        mainScreenShellRoutes,
        ...otherRoutes,
        ...authRoutes,
        adminShellRoute,
      ],
    ),
  ],
);

class CrabPayApp extends StatelessWidget {
  const CrabPayApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          ColorScheme lightScheme;
          if (lightDynamic != null) {
            lightScheme = ColorScheme.fromSeed(
              seedColor: lightDynamic.primary,
              brightness: Brightness.light,
            );
          } else {
            lightScheme = ColorScheme.fromSeed(seedColor: Colors.red);
          }

          ColorScheme darkScheme;
          if (darkDynamic != null) {
            darkScheme = ColorScheme.fromSeed(
              seedColor: darkDynamic.primary,
              brightness: Brightness.dark,
            );
          } else {
            darkScheme = ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.dark,
            );
          }
          final overlayKey = GlobalKey<OverlayState>();
          getIt<InnerLoggerHandler>().logBreadcrumb(
            message: 'CrabPayApp build',
          );
          return MaterialApp.router(
            // showPerformanceOverlay: true,
            // debugShowMaterialGrid: true,
            debugShowCheckedModeBanner: false,
            title: 'CrabPay Demo',
            theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),
            darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
            routerConfig: _appRouter,
            builder: (context, child) {
              return GlobalLoaderStack(
                child: Overlay(
                  key: overlayKey,
                  initialEntries: [OverlayEntry(builder: (context) => child!)],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
