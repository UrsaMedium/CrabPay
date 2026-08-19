import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/views/main_screen/driver/main_screen_cubit.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/support_page/driver/support_page_driver.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/driver/store_page_driver.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/home_page/driver/home_page_driver.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/cart_page/cart_page_driver.dart';
import 'package:crabpay/views/main_screen/view/material/material_main_screen_view.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainScreenDriver extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainScreenDriver({super.key, required this.navigationShell});

  @override
  State<MainScreenDriver> createState() => _MainScreenDriverState();
}

class _MainScreenDriverState extends State<MainScreenDriver> {
  late final PageController _pageController;
  late final MainScreenCubit _mainScreenCubit;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
    _mainScreenCubit = MainScreenCubit(
      globalKey: GlobalKey(),
      authBloc: context.read<AuthBloc>(),
      cartBloc: context.read<CartBloc>(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mainScreenCubit.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MainScreenDriver oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_pageController.hasClients &&
        _pageController.page?.round() != widget.navigationShell.currentIndex &&
        !_mainScreenCubit.state.isSyncingByNavBarTap) {
      _pageController.animateToPage(
        widget.navigationShell.currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  final List<Widget> _pages = const [
    HomePageDriver(),
    StorePageDriver(),
    SupportPageDriver(),
    CartPageDriver(),
  ];

  void _onPageSwiped(int index) {
    if (_mainScreenCubit.state.isSyncingByNavBarTap) return;
    widget.navigationShell.goBranch(index);
    _mainScreenCubit.onPageSwipe(index);
  }

  void _onPageSelected(int index) async {
    if (index == widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(index, initialLocation: true);
      return;
    }
    _mainScreenCubit.setSyncByNavBarState(true);
    widget.navigationShell.goBranch(index);
    _mainScreenCubit.onPageSwipe(index);
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _mainScreenCubit.setSyncByNavBarState(false);
  }

  void _onProfileIconPressed({required BuildContext context}) {
    if (_mainScreenCubit.state.isLoggedIn) {
      context.push(AppRoutes.profileSheet.path);
    } else {
      final renderBox =
          _mainScreenCubit.state.profileIconButtonKey.currentContext
                  ?.findRenderObject()
              as RenderBox?;
      if (renderBox == null) {
        Fluttertoast.showToast(msg: 'Login Button Error');
        return;
      }
      final position = renderBox.localToGlobal(Offset.zero);
      final centerOffset = Offset(
        position.dx + (renderBox.size.width / 2),
        position.dy + (renderBox.size.height / 2),
      );
      context.push(AppRoutes.login.path, extra: centerOffset);
    }
  }

  void _onOrdersPressed(BuildContext context) {
    context.push(AppRoutes.orders.path);
  }

  void _onAdminPressed(BuildContext context) {
    context.push(AppRoutes.adminTools.path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mainScreenCubit,
      child: BlocListener<MainScreenCubit, MainScreenState>(
        listenWhen: (previous, current) => current.page != previous.page,
        listener: (context, state) {
          if (state.currentUser != null) {
            switch (state.page) {
              case 0:
                context.read<DatabaseBloc>().add(
                  DatabaseEventFetchUserPreferences(
                    userId: state.currentUser!.id,
                  ),
                );
                break;
              case 1:
                break;
              case 2:
                break;
              case 3:
                context.read<CartBloc>().add(
                  CartEventFetchCartItems(userId: state.currentUser!.id),
                );
                break;
              default:
            }
          }
        },
        child: Builder(
          builder: (context) {
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              // cupertino
            }
            return MaterialMainScreenView(
              onPageSelected: (index) => _onPageSelected(index),
              onPageSwiped: (index) => _onPageSwiped(index),
              onProfileIconPressed: () =>
                  _onProfileIconPressed(context: context),
              pageController: _pageController,
              pages: _pages,
              onOrdersPressed: () => _onOrdersPressed(context),
              onAdminPressed: () => _onAdminPressed(context),
            );
          },
        ),
      ),
    );
  }
}
