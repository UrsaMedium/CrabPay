import 'package:crabpay/views/auth_views/login_view.dart';
import 'package:crabpay/views/auth_views/password_forgot_view.dart';
import 'package:crabpay/views/auth_views/register_view.dart';
import 'package:crabpay/views/home_view/bloc/page_view_and_navigation_bar_sync_bloc/home_pages_bloc.dart';
import 'package:crabpay/views/home_view/home_view.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CrabPayApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const HomeView(),
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) =>
              const LoginView(),
          routes: <RouteBase>[
            GoRoute(
              path: 'register',
              builder: (BuildContext context, GoRouterState state) =>
                  const RegisterView(),
            ),
            GoRoute(
              path: 'password-forgot',
              builder: (BuildContext context, GoRouterState state) =>
                  const PasswordForgotView(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class CrabPayApp extends StatelessWidget {
  const CrabPayApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
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
            // contrastLevel: 0.5,
            // dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
          );
        } else {
          darkScheme = ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: Brightness.dark,
          );
        }

        return BlocProvider(
          create: (context) => HomeViewBloc(),
          child: MaterialApp.router(
            title: 'CrabPay Demo',
            theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),
            darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
            routerConfig: _router,
          ),
        );
      },
    );
  }
}
