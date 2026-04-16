import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/views/store_views/bloc/page_view_and_navigation_bar_sync_bloc/home_pages_bloc.dart';
import 'package:crabpay/views/store_views/bloc/page_view_and_navigation_bar_sync_bloc/home_pages_event.dart';
import 'package:crabpay/views/store_views/bloc/page_view_and_navigation_bar_sync_bloc/home_pages_state.dart';
import 'package:crabpay/views/store_views/store_pages/cart_page_view.dart';
import 'package:crabpay/views/store_views/store_pages/home_page_view.dart';
import 'package:crabpay/views/store_views/store_pages/store_page_view.dart';
import 'package:crabpay/views/store_views/store_pages/ask_page_view.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/store_views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            builder: (context, state) {
              if (state is AuthStateLoggedIn) {
                return IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (BuildContext context) => ProfileView(),
                    );
                  },
                  icon: Icon(Icons.account_circle_rounded),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    context.go('/login_view');
                  },
                  icon: Icon(Icons.account_circle_outlined),
                );
              }
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _emitOnPageChangeEventAndChangeTab,
        children: const [
          HomePageView(),
          StorePageView(),
          AskPageView(),
          CartPageView(),
        ],
      ),
      bottomNavigationBar: BlocBuilder<HomeViewBloc, HomeViewState>(
        builder: (context, state) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: NavigationBar(
              selectedIndex: _pageIndex,
              onDestinationSelected: _emitOnTabTapEventAndChangePage,
              destinations: const [
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
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart_checkout_outlined),
                  selectedIcon: Icon(Icons.shopping_cart_rounded),
                  label: 'Cart',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _emitOnTabTapEventAndChangePage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    _pageIndex = index;
    context.read<HomeViewBloc>().add(
      HomeViewOnPageSwipeEvent(pageIndex: index),
    );
  }

  void _emitOnPageChangeEventAndChangeTab(int index) {
    _pageIndex = index;
    context.read<HomeViewBloc>().add(
      HomeViewOnPageSwipeEvent(pageIndex: index),
    );
  }
}
