import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class MaterialMainScreenView extends StatelessWidget {
  final int itemsCount;
  final int pageIndex;
  final VoidCallback onProfileIconPressed;
  final VoidCallback onCasesPressed;
  final VoidCallback onAdminPressed;
  final Function(int) onPageSelected;
  final Function(int) onPageSwiped;
  final PageController pageController;
  final List<Widget> pages;
  final bool isLoggedIn;
  final bool isAdmin;
  const MaterialMainScreenView({
    super.key,
    required this.onProfileIconPressed,
    required this.pageIndex,
    required this.onPageSelected,
    required this.itemsCount,
    required this.pageController,
    required this.onPageSwiped,
    required this.pages,
    required this.isLoggedIn,
    required this.onCasesPressed,
    required this.onAdminPressed,
    required this.isAdmin,
  });
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
          if (isAdmin)
            IconButton(onPressed: onAdminPressed, icon: Icon(Icons.settings)),
          if (isLoggedIn)
            IconButton(
              onPressed: onCasesPressed,
              icon: Icon(Icons.cases_rounded),
            ),
          isLoggedIn
              ? IconButton(
                  onPressed: onProfileIconPressed,
                  icon: Icon(Icons.account_circle_rounded),
                )
              : IconButton(
                  onPressed: onProfileIconPressed,
                  icon: Icon(Icons.account_circle_outlined),
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
        physics: const CustomFasterPageScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageSwiped,
        children: pages,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        child: BackdropFilter(
          filter: .blur(sigmaX: 8, sigmaY: 8),
          child: NavigationBar(
            selectedIndex: pageIndex,
            onDestinationSelected: onPageSelected,
            backgroundColor: context.appColorScheme.surfaceContainer.withValues(
              alpha: .8,
            ),
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
              NavigationDestination(
                icon: Badge(
                  backgroundColor: context.appColorScheme.error,
                  textColor: context.appColorScheme.onError,
                  label: Text(itemsCount > 0 ? itemsCount.toString() : ''),
                  isLabelVisible: itemsCount > 0,
                  child: Icon(Icons.shopping_cart_checkout_outlined),
                ),
                selectedIcon: Badge(
                  backgroundColor: context.appColorScheme.error,
                  textColor: context.appColorScheme.onError,
                  label: Text(itemsCount > 0 ? itemsCount.toString() : ''),
                  isLabelVisible: itemsCount > 0,
                  child: Icon(Icons.shopping_cart_rounded),
                ),
                label: 'Cart',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
