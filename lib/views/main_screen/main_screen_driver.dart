import 'dart:developer';

import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/views/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/support_page/support_page_driver.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/store_page/store_page_driver.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/home_page/home_page_driver.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/cart_page/cart_page_driver.dart';
import 'package:crabpay/views/main_screen/material_main_screen_view.dart';
import 'package:crabpay/views/main_screen/sub/profile_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
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
  bool _isSyncingByNavBarTap = false;
  final GlobalKey profileIconButtonKey = GlobalKey();

  @override
  void initState() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'MainScreenDriver initState',
    );
    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
    super.initState();
  }

  @override
  void dispose() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'MainScreenDriver dispose',
    );
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MainScreenDriver oldWidget) {
     Timeline.startSync('Data_Processing_Tweak_V2');
    super.didUpdateWidget(oldWidget);
    if (_pageController.hasClients &&
        _pageController.page?.round() != widget.navigationShell.currentIndex &&
        !_isSyncingByNavBarTap) {
      _pageController.animateToPage(
        widget.navigationShell.currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    Timeline.finishSync();
  }

  final List<Widget> _pages = const [
    HomePageDriver(),
    StorePageDriver(),
    SupportPageDriver(),
    CartPageDriver(),
  ];

  void _onPageSwiped(int index, MainScreenCubit cubit) {
    Timeline.startSync('Data_Processing_Tweak_V2');
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'MainScreenDriver _onPageSwiped',
      data: {'index': index},
    );
    if (_isSyncingByNavBarTap) return;
    widget.navigationShell.goBranch(index);
    cubit.onPageSwipe(index);
    Timeline.finishSync();
  }

  void _onPageSelected(int index, MainScreenCubit cubit) async {
    Timeline.startSync('Data_Processing_Tweak_V2');
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'MainScreenDriver _onPageSelected',
      data: {'index': index},
    );
    if (index == widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(index, initialLocation: true);
      Timeline.finishSync();
      return;
    }
    setState(() => _isSyncingByNavBarTap = true);
    widget.navigationShell.goBranch(index);
    cubit.onPageSwipe(index);
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    if (mounted) {
      setState(() => _isSyncingByNavBarTap = false);
    }
    Timeline.finishSync();
  }

  void _onProfileIconPressed({
    required bool isLoggedIn,
    required BuildContext context,
    required Offset buttonCenter,
  }) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'MainScreenDriver _onProfileIconPressed',
      data: {'isLoggedIn': isLoggedIn},
    );
    if (isLoggedIn) {
      showModalBottomSheet(
        useRootNavigator: false,
        showDragHandle: false,
        useSafeArea: false,
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: context.appColorScheme.surfaceContainerHighest
            .withValues(alpha: .5),
        builder: (BuildContext sheetContext) => ProfileViewDriver(),
      );
    } else {
      context.push(AppRoutes.login.path, extra: buttonCenter);
    }
  }

  void _onPurchasesPressed(BuildContext context) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'MainScreenDriver _onPurchasesPressed',
    );
    context.push(AppRoutes.purchases.path);
  }

  void _onAdminPressed(BuildContext context) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'MainScreenDriver _onAdminPressed',
    );
    context.push(AppRoutes.adminTools.path);
  }

  bool _isLoggedIn(AuthState authState) {
    return !(authState.currentUser.email == null ||
        authState.currentUser.isAnonymous);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocProvider(
          create: (_) => MainScreenCubit(),
          child: BlocBuilder<MainScreenCubit, MainScreenState>(
            builder: (context, viewState) {
              final cubit = context.read<MainScreenCubit>();
              final itemsCount = context.select<CartBloc, int>(
                (bloc) => bloc.state.userCartItemAmount ?? 0,
              );

              if (defaultTargetPlatform == TargetPlatform.iOS) {
                // cupertino
              }

              return MaterialMainScreenView(
                itemsCount: itemsCount,
                onPageSelected: (index) => _onPageSelected(index, cubit),
                onPageSwiped: (index) => _onPageSwiped(index, cubit),
                onProfileIconPressed: (Offset center) => _onProfileIconPressed(
                  isLoggedIn: _isLoggedIn(authState),
                  context: context,
                  buttonCenter: center,
                ),
                pageController: _pageController,
                pageIndex: viewState.page,
                pages: _pages,
                isLoggedIn: _isLoggedIn(authState),
                onPurchasesPressed: () => _onPurchasesPressed(context),
                onAdminPressed: () => _onAdminPressed(context),
                isAdmin: context.read<AuthBloc>().state.currentUser.isAdmin,
                profileIconButtonKey: profileIconButtonKey,
              );
            },
          ),
        );
      },
    );
  }
}

@immutable
class MainScreenState {
  final int page;

  const MainScreenState({this.page = 0});

  MainScreenState copyWith({int? page}) {
    return MainScreenState(page: page ?? this.page);
  }
}

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit({int initialPage = 0})
    : super(MainScreenState(page: initialPage));

  void onPageSwipe(int index) {
    if (state.page != index) {
      emit(state.copyWith(page: index));
    }
  }
}
