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
  final List<Rect> cameraBounds;
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
    required this.cameraBounds,
  });
  @override
  Widget build(BuildContext context) {
    final inRadius = 28.0;
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
            top: MediaQuery.paddingOf(context).top + 2,
            left: 6,
            right: 6,
            child: ClipRRect(
              borderRadius: .circular(22),
              child: BackdropFilter(
                filter: .blur(sigmaX: 12, sigmaY: 8),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    // borderRadius: .circular(22),
                    color: context.appColorScheme.surfaceContainer.withValues(
                      alpha: .8,
                    ),
                  ),
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
          ClipPath(
            clipper: AppUpwardReveresClipper(radius: inRadius, isUpward: true),
            child: BackdropFilter(
              filter: .blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: context.appColorScheme.surfaceContainerHigh,
                height: cameraBounds.first.height + inRadius - 4,
              ),
            ),
          ),
          Positioned(
            // top: MediaQuery.paddingOf(context).bottom + inRadius,
            bottom: 58,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: AppUpwardReveresClipper(
                radius: inRadius,
                isUpward: false,
              ),
              child: Container(
                color: context.appColorScheme.surfaceContainerHigh,
                height: inRadius,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        height: 58,
        onDestinationSelected: onPageSelected,
        backgroundColor: context.appColorScheme.surfaceContainerHigh,
        destinations: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_filled),
              label: 'Home',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront),
              label: 'Store',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: NavigationDestination(
              icon: Icon(Icons.message_outlined),
              selectedIcon: Icon(Icons.message_rounded),
              label: 'Ask',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: NavigationDestination(
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
          ),
        ],
      ),
    );
  }
}
