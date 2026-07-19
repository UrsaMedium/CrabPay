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
      body: Stack(
        children: [
          PageView(
            physics: const CustomFasterPageScrollPhysics(),
            controller: pageController,
            onPageChanged: onPageSwiped,
            children: pages,
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top-8,
            left: 0,
            right: 0,
            child: Card(
              color: context.appColorScheme.secondaryContainer.withValues(
                alpha: .8,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: context.appColorScheme.onSecondaryContainer,
                  width: 1,
                ),
                borderRadius: .circular(30),
              ),
              child: ClipRRect(
                borderRadius: .circular(30),
                child: BackdropFilter(
                  filter: .blur(sigmaX: 8, sigmaY: 8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          '🦀 Crab Pay',
                          style: TextStyle(
                            color: context.appColorScheme.primary,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
                      if (isAdmin)
                        IconButton(
                          onPressed: onAdminPressed,
                          icon: Icon(Icons.settings),
                        ),
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
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        child: BackdropFilter(
          filter: .blur(sigmaX: 8, sigmaY: 8),
          child: NavigationBar(
            selectedIndex: pageIndex,
            onDestinationSelected: onPageSelected,
            backgroundColor: context.appColorScheme.surfaceContainer.withValues(
              alpha: .95,
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
