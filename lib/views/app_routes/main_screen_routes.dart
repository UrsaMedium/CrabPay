import 'package:crabpay/views/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/main_screen_driver.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/cart_page/cart_page_driver.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/home_page/home_page_driver.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/store_page/store_page_driver.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/support_page/support_page_driver.dart';
import 'package:go_router/go_router.dart';

final RouteBase mainScreenShellRoutes = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MainScreenDriver(navigationShell: navigationShell);
  },
  branches: <StatefulShellBranch>[
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.home.path,
          name: AppRoutes.home.name,
          builder: (context, state) => const HomePageDriver(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.store.path,
          name: AppRoutes.store.name,
          builder: (context, state) => StorePageDriver(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.support.path,
          name: AppRoutes.support.name,
          builder: (context, state) {
            final orderId = state.uri.queryParameters['orderId'];
            // Format the command string cleanly inside Dart, not the URL bar:
            final initialMessage = orderId != null
                ? '-new ticket-\n$orderId\n'
                : null;
            return SupportPageDriver(message: initialMessage);
          },
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.cart.path,
          name: AppRoutes.cart.name,
          builder: (context, state) => const CartPageDriver(),
        ),
      ],
    ),
  ],
);
