import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/_sub/settings_sheet.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/_sub/store_category_view.dart';
import 'package:crabpay/views/main_screen/driver/main_screen_driver.dart';
import 'package:crabpay/views/main_screen/_sub/profile_sheet.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/cart_page/driver/cart_page_driver.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/cart_page/orders_on_payment_sheet.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/home_page/driver/home_page_driver.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/driver/store_page_driver.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/support_page/driver/support_page_driver.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_bottom_sheet_page_gorouter_interface.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> mainScreenShellRoutes = [
  GoRoute(
    path: AppRoutes.profileSheet.path,
    name: AppRoutes.profileSheet.name,
    pageBuilder: (context, state) =>
        BottomSheetPage(key: state.pageKey, child: const ProfileSheetDriver()),
  ),
  GoRoute(
    path: AppRoutes.settingsSheet.path,
    name: AppRoutes.settingsSheet.name,
    pageBuilder: (context, state) =>
        BottomSheetPage(key: state.pageKey, child: const SettingsSheetDriver()),
  ),
  // GoRoute(
  //   path: AppRoutes.storeCategoryView.path,
  //   name: AppRoutes.storeCategoryView.name,
  //   builder: (context, state) {
  //     return StoreCategoryViewDriver(tag: state.pathParameters['tag'] ?? '');
  //   },
  // ),
  GoRoute(
    path: AppRoutes.itemsOnPaymentSheet.path,
    name: AppRoutes.itemsOnPaymentSheet.name,
    pageBuilder: (context, state) => BottomSheetPage(
      key: state.pageKey,
      child: const OrdersOnPaymentSheetDriver(),
    ),
  ),
  StatefulShellRoute.indexedStack(
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
            builder: (context, state) => const StorePageDriver(),
            routes: [
              GoRoute(
                path: AppRoutes.storeCategoryView.path,
                name: AppRoutes.storeCategoryView.name,
                builder: (context, state) {
                  return StoreCategoryViewDriver(
                    tag: state.pathParameters['tag'] ?? '',
                  );
                },
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.support.path,
            name: AppRoutes.support.name,
            builder: (context, state) => const SupportPageDriver(),
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
  ),
];
