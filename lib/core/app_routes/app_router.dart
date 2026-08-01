import 'package:crabpay/core/app_routes/admin_routes.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/core/app_routes/auth_routes.dart';
import 'package:crabpay/core/app_routes/main_screen_routes.dart';
import 'package:crabpay/core/app_routes/other_routes.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home.path,
  routes: <RouteBase>[
    ...mainScreenShellRoutes,
    ...otherRoutes,
    ...authRoutes,
    adminShellRoute,
  ],
);
