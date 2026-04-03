import 'package:crabpay/home_view/bloc/home_pages_navigation_bloc/home_pages_bloc.dart';
import 'package:crabpay/home_view/bloc/home_pages_navigation_bloc/home_pages_event.dart';
import 'package:crabpay/home_view/bloc/home_pages_navigation_bloc/home_pages_state.dart';
import 'package:crabpay/home_view/home_pages/home_page_view.dart';
import 'package:crabpay/home_view/home_pages/store_page_view.dart';
import 'package:crabpay/home_view/home_pages/wallet_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    
    _pageController.animateToPage(
      selectedIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crab Pay')),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged, 
        children: const [HomePageView(), StorePageView(), WalletPageView()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped, 
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Sotre',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
        ],
      ),
    );
  }
}

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   final PageController _pageController = PageController();
//   int _bottomBarIndex = 0;

//   @override
//   void dispose() {
//     super.dispose();
//     _pageController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Crab Pay')),
//       body: PageView(
//         controller: _pageController,
//         onPageChanged: (index) {
//           // context.read<HomePagesBloc>().add(
//           //   HomePagesEventOnPageChange(index: index),
//           // );
//           _bottomBarIndex = index;
//         },
//         children: [HomePageView(), StorePageView(), WalletPageView()],
//       ),
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _bottomBarIndex,
//         onDestinationSelected: (index) {
//           // context.read<HomePagesBloc>().add(
//           //   HomePagesEventOnPageChange(index: index),
//           // );
//           _pageController.animateToPage(
//             index,
//             duration: const Duration(microseconds: 300),
//             curve: Curves.easeInBack,
//           );
//         },
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined),
//             selectedIcon: Icon(Icons.home_filled),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.storefront_outlined),
//             selectedIcon: Icon(Icons.storefront),
//             label: 'Sotre',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.account_balance_wallet_outlined),
//             selectedIcon: Icon(Icons.account_balance_wallet),
//             label: 'Wallet',
//           ),
//         ],
//       ),
//     );
//   }
// }
