import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_outer_circle/outer_cart_handler.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s3_price_space_filling/s3_price_space_fill_view.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s2_add_fields_views/s2_add_product_fields_view.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s1_add_complete_product_product_view.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_outer_circle/outer_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_outer_circle/firebase_outer_interface.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s4_data_overview_view.dart';
import 'package:crabpay/views/admin_views/add_field_admin_panel.dart';
import 'package:crabpay/views/admin_views/update_field_admin_panel_view.dart';
import 'package:crabpay/views/store_views/store_pages/bloc/bloc_for_page_scrolling/home_pages_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_bloc.dart';
import 'package:crabpay/views/store_views/store_pages/store_page/store_page_view.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/card_view.dart';
import 'package:crabpay/views/admin_views/delete_instances_from_db_view.dart';
import 'package:crabpay/views/store_views/store_pages/home_page_view.dart';
import 'package:crabpay/views/store_views/store_pages/cart_page_view.dart';
import 'package:crabpay/views/admin_views/add_featured_product_view.dart';
import 'package:crabpay/views/store_views/store_pages/ask_page_view.dart';
import 'package:crabpay/views/auth_views/password_forgot_view.dart';
import 'package:crabpay/views/admin_views/update_product_admin_panel_view.dart';
import 'package:crabpay/core/local_storage/local_storage.dart';
import 'package:crabpay/views/auth_views/register_view.dart';
import 'package:crabpay/views/auth_views/login_view.dart';
import 'package:crabpay/views/store_views/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorage.init();

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(FirebaseOuterInterface()),
      child: BlocProvider(
        create: (context) => DatabaseBloc(OuterDatabaseHandler()),
        child: BlocProvider(
          create: (context) => CartBloc(OuterCartHandler()),
          child: const CrabPayApp(),
        ),
      ),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BlocProvider(
          create: (context) => HomeViewBloc(),
          child: HomeView(navigationShell: navigationShell),
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePageView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/store',
              builder: (context, state) => StorePageView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/ask',
              builder: (context, state) => const AskPageView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartPageView(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/store/card_view/:productId/:additionalSuffix/:index',
      name: 'card_view',
      pageBuilder: (context, state) {
        final productId = state.pathParameters['productId'] ?? '0';
        final additionalSuffix =
            state.pathParameters['additionalSuffix'] ?? '0';
        final index = state.pathParameters['index'] ?? '0';
        return CustomTransitionPage(
          key: state.pageKey,
          child: CardView(
            productId: productId,
            additionalSuffix: additionalSuffix,
            index: index,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    // GoRoute(
    //   path: '/profile_view',
    //   name: 'profile_view',
    //   builder: (context, state) => ProfileView(),
    // ),
    ShellRoute(
      builder: (context, state, child) =>
          BlocProvider(create: (context) => AdminBloc(), child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/add_complete_product_product_view',
          name: 'add_complete_product_product_view',
          builder: (BuildContext context, GoRouterState state) =>
              const AddCompleteProductProductView(),
          routes: <RouteBase>[
            GoRoute(
              path: 'add_product_fields_view',
              builder: (context, state) => const AddProductFieldsView(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'price_space_fill_view',
                  builder: (context, state) => const PriceSpaceFillView(),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'data_overview_view',
                      builder: (context, state) => const DataOverviewView(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/deleting_view',
      builder: (context, state) => DeleteInstancesFromDbView(),
    ),
    GoRoute(
      path: '/update_product_admin_panel_view/:productId',
      name: 'update_product_admin_panel_view',
      builder: (context, state) {
        final productId = state.pathParameters['productId'];
        return UpdateProductAdminPanelView(productId: productId);
      },
    ),
    GoRoute(
      path: '/update_field_admin_panel_view/:fieldId',
      name: 'update_field_admin_panel_view',
      builder: (context, state) {
        final fieldId = state.pathParameters['fieldId'];
        return UpdateFieldAdminPanelView(fieldId: fieldId);
      },
    ),
    GoRoute(
      path: '/add_field_admin_panel_view/:productId',
      name: 'add_field_admin_panel_view',
      builder: (context, state) {
        final productId = state.pathParameters['productId'];
        return AddFieldAdminPanelView(productId: productId);
      },
    ),
    GoRoute(
      path: '/add_featured_product_view',
      builder: (context, state) => AddFeaturedProductView(),
    ),
    GoRoute(
      path: '/login_view',
      name: 'login_view',
      builder: (BuildContext context, GoRouterState state) => const LoginView(),
      routes: <RouteBase>[
        GoRoute(
          path: 'register_view',
          builder: (BuildContext context, GoRouterState state) =>
              const RegisterView(),
        ),
        GoRoute(
          path: 'password-forgot_view',
          builder: (BuildContext context, GoRouterState state) =>
              const PasswordForgotView(),
        ),
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
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'CrabPay Demo',
            theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),
            darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
            routerConfig: _router,
            builder: (context, child) {
              return Overlay(
                key: overlayKey,
                initialEntries: [OverlayEntry(builder: (context) => child!)],
              );
            },
          );
        },
      ),
    );
  }
}
