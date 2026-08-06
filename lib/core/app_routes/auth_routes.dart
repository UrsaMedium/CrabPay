import 'package:crabpay/core/custom_ui_elements/app_expanding_circle_transition.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/sub/auth_views/login_view/login_view_driver.dart';
import 'package:crabpay/views/main_screen/sub/auth_views/password_forgot_view/password_forgot_view_driver.dart';
import 'package:crabpay/views/main_screen/sub/auth_views/register_view/register_view_driver.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> authRoutes = [
  GoRoute(
    path: AppRoutes.login.path,
    name: AppRoutes.login.name,
    pageBuilder: (context, state) =>
        AppExpandingCircleTransitionRoute.circularReveal(
          context: context,
          state: state,
          child: const LoginViewDriver(),
        ),
    routes: [
      GoRoute(
        path: AppRoutes.register.path,
        name: AppRoutes.register.name,
        builder: (context, state) => const RegisterViewDriver(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword.path,
        name: AppRoutes.resetPassword.name,
        builder: (context, state) => const PasswordForgotViewDriver(),
      ),
    ],
  ),
];
