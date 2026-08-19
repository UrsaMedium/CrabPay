// lib/core/routing/modules/admin_routes.dart
import 'package:crabpay/views/main_screen/_sub/admin_views/add_complete_product_and_field_data/bloc/admin_bloc.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/add_complete_product_and_field_data/s1_add_complete_product_product_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/add_complete_product_and_field_data/s2_add_fields_views/s2_add_product_fields_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/add_complete_product_and_field_data/s3_price_space_filling/s3_price_space_fill_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/add_complete_product_and_field_data/s4_data_overview_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/add_featured_product_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/add_field_admin_panel.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/admin_support_chat/admin_support_chat.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/admin_support_chat/choose_thread.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/admin_tools_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/delete_instances_from_db_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/reset_price_image_field_admin_panel_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/update_field_admin_panel_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/update_price_images_field_admin_panel_view.dart';
import 'package:crabpay/views/main_screen/_sub/admin_views/update_product_admin_panel_view.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final RouteBase adminShellRoute = ShellRoute(
  builder: (context, state, child) =>
      BlocProvider(create: (context) => AdminBloc(), child: child),
  routes: [
    GoRoute(
      path: AppRoutes.addCompleteProduct.path,
      name: AppRoutes.addCompleteProduct.name,
      builder: (context, state) => const AddCompleteProductProductView(),
      routes: [
        GoRoute(
          path: AppRoutes.addProductFields.path,
          name: AppRoutes.addProductFields.name,
          builder: (context, state) => const AddProductFieldsView(),
          routes: [
            GoRoute(
              path: AppRoutes.priceSpaceFill.path,
              name: AppRoutes.priceSpaceFill.name,
              builder: (context, state) => const PriceSpaceFillView(),
              routes: [
                GoRoute(
                  path: AppRoutes.dataOverview.path,
                  name: AppRoutes.dataOverview.name,
                  builder: (context, state) => const DataOverviewView(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Admin Tools & Support Chat
    GoRoute(
      path: AppRoutes.adminTools.path,
      name: AppRoutes.adminTools.name,
      builder: (context, state) => const AdminToolsView(),
      routes: [
        GoRoute(
          path: AppRoutes.chooseThread.path,
          name: AppRoutes.chooseThread.name,
          builder: (context, state) => const ChooseThreadView(),
          routes: [
            GoRoute(
              path: AppRoutes.adminSupportChat.path,
              name: AppRoutes.adminSupportChat.name,
              builder: (context, state) => AdminSupportChatView(
                threadId: state.pathParameters['threadId'] ?? '',
              ),
            ),
          ],
        ),
      ],
    ),
    // Standalone Admin Management Panels
    GoRoute(
      path: AppRoutes.updateProduct.path,
      name: AppRoutes.updateProduct.name,
      builder: (context, state) => UpdateProductAdminPanelView(
        productId: state.pathParameters['productId'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.updateField.path,
      name: AppRoutes.updateField.name,
      builder: (context, state) => UpdateFieldAdminPanelView(
        fieldId: state.pathParameters['fieldId'] ?? '',
        productId: state.pathParameters['productId'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.updatePriceImages.path,
      name: AppRoutes.updatePriceImages.name,
      builder: (context, state) => UpdatePriceImagesFieldAdminPanelView(
        fieldId: state.pathParameters['fieldId'] ?? '',
        productId: state.pathParameters['productId'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.addField.path,
      name: AppRoutes.addField.name,
      builder: (context, state) => AddFieldAdminPanelView(
        productId: state.pathParameters['productId'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.resetPriceImage.path,
      name: AppRoutes.resetPriceImage.name,
      builder: (context, state) => ResetPriceImageFieldAdminPanelView(
        productId: state.pathParameters['productId'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.deleting.path,
      name: AppRoutes.deleting.name,
      builder: (context, state) => const DeleteInstancesFromDbView(),
    ),
    GoRoute(
      path: AppRoutes.addFeaturedProduct.path,
      name: AppRoutes.addFeaturedProduct.name,
      builder: (context, state) => const AddFeaturedProductView(),
    ),
  ],
);
