import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
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
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

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
        onPageChanged: (index) => setState(() {
          _pageIndex = index;
        }),
        children: const [
          HomePageView(),
          StorePageView(),
          AskPageView(),
          CartPageView(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        child: NavigationBar(
          selectedIndex: _pageIndex,
          onDestinationSelected: (index) => setState(() {
            _pageIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          }),
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
      ),
    );
  }
}
