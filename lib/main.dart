import 'package:crabpay/views/auth_views/login_view.dart';
import 'package:crabpay/views/home_view/bloc/page_view_and_navigation_bar_sync_bloc/home_pages_bloc.dart';
import 'package:crabpay/views/home_view/home_view.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CrabPayApp());
}

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
            // contrastLevel: 0.5,
            // dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
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

        return MaterialApp(
          title: 'CrabPay Demo',
          theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),
          darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
          home: BlocProvider(
            create: (context) => HomeViewBloc(),
            child: const LoginView(),
          ),
        );
      },
    );
  }
}
