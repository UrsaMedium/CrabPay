import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_events.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/views/store_views/store_pages/bloc/bloc_for_page_scrolling/home_pages_event.dart';
import 'package:crabpay/views/store_views/store_pages/bloc/bloc_for_page_scrolling/home_pages_state.dart';
import 'package:crabpay/views/store_views/store_pages/bloc/bloc_for_page_scrolling/home_pages_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/views/store_views/store_pages/store_page/store_page_view.dart';
import 'package:crabpay/views/store_views/store_pages/cart_page_view.dart';
import 'package:crabpay/views/store_views/store_pages/home_page_view.dart';
import 'package:crabpay/views/store_views/store_pages/ask_page_view.dart';
import 'package:crabpay/views/store_views/profile_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const HomeView({super.key, required this.navigationShell});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final PageController _pageController;
  bool _isSyncingByNavBarTap = false;
  int itemsCount = 0;
  late final AuthUser currentUser;

  @override
  void initState() {
    context.read<AuthBloc>().add(AuthEventInitialize(context: context));
    currentUser = context.read<AuthBloc>().state.currentUser ?? appTempUser;
    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
    if (context.read<DatabaseBloc>().state.products?.isEmpty ?? true) {
      context.read<DatabaseBloc>().add(
        DatabaseEventInitialize(userId: currentUser.id),
      );
      context.read<CartBloc>().add(
        CartEventFetchUserCartItemAmount(userId: currentUser.id),
      );
    }
    itemsCount = context.read<CartBloc>().state.userCartItemAmount ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: context.appColorScheme.surfaceContainerLowest
            .withValues(alpha: .8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: context.appColorScheme.surfaceBright,
            width: 1,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        title: Text('Crab Pay'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (blocContext, state) {
              if (state is AuthStateLoggedIn) {
                return IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      useRootNavigator: false,
                      showDragHandle: false,
                      useSafeArea: false,
                      context: blocContext,
                      enableDrag: true,
                      isScrollControlled: true,
                      backgroundColor: blocContext
                          .appColorScheme
                          .surfaceContainerLow
                          .withValues(alpha: .5),

                      builder: (BuildContext sheetContext) => Wrap(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const .only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              border: .all(
                                color: blocContext
                                    .appColorScheme
                                    .surfaceContainerLow
                                    .withValues(alpha: .5),
                              ),
                            ),
                            child: ProfileView(),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.account_circle_rounded),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    context.push('login_view');
                  },
                  icon: Icon(Icons.account_circle_outlined),
                );
              }
            },
          ),
        ],
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadiusGeometry.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          child: BackdropFilter(
            filter: .blur(sigmaX: 8, sigmaY: 8),
            child: Container(),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _handlePageSwipe,
        children: [
          _buildIsolatedBranch(const HomePageView()),
          _buildIsolatedBranch(const StorePageView()),
          _buildIsolatedBranch(const AskPageView()),
          _buildIsolatedBranch(const CartPageView()),
        ],
      ),
      bottomNavigationBar: BlocBuilder<HomeViewBloc, HomeViewState>(
        builder: (context, state) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: BackdropFilter(
              filter: .blur(sigmaX: 8, sigmaY: 8),
              child: NavigationBar(
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: _handleNavBarTap,
                backgroundColor: context.appColorScheme.surfaceContainer
                    .withValues(alpha: .8),
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_filled),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.storefront_outlined),
                    selectedIcon: Icon(Icons.storefront),
                    label: 'Store',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.message_outlined),
                    selectedIcon: Icon(Icons.message_rounded),
                    label: 'Ask',
                  ),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      itemsCount = state.userCartItemAmount ?? 0;
                      return NavigationDestination(
                        icon: Badge(
                          backgroundColor: context.appColorScheme.error,
                          textColor: context.appColorScheme.onError,
                          label: Text(itemsCount.toString()),
                          isLabelVisible: itemsCount > 0,
                          child: Icon(Icons.shopping_cart_checkout_outlined),
                        ),
                        selectedIcon: Badge(
                          backgroundColor: context.appColorScheme.error,
                          textColor: context.appColorScheme.onError,
                          label: Text(itemsCount.toString()),
                          isLabelVisible: itemsCount > 0,
                          child: Icon(Icons.shopping_cart_rounded),
                        ),
                        label: 'Cart',
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIsolatedBranch(Widget page) {
    return Navigator(
      onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (context) => page),
    );
  }

  void _handlePageSwipe(int index) {
    if (_isSyncingByNavBarTap) return;

    widget.navigationShell.goBranch(index);
    context.read<HomeViewBloc>().add(
      HomeViewOnPageSwipeEvent(pageIndex: index),
    );
  }

  void _handleNavBarTap(int index) async {
    if (index == widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(index, initialLocation: true);
      return;
    }

    setState(() => _isSyncingByNavBarTap = true);

    widget.navigationShell.goBranch(index);
    context.read<HomeViewBloc>().add(
      HomeViewOnPageSwipeEvent(pageIndex: index),
    );

    // Smoothly animate the page swap when a tab item is clicked
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    if (mounted) {
      setState(() => _isSyncingByNavBarTap = false);
    }
  }
}
