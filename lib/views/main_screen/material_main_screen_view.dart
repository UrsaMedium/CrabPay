import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MaterialMainScreenView extends StatelessWidget {
  final int itemsCount;
  final int pageIndex;
  final Function(Offset) onProfileIconPressed;
  final VoidCallback onCasesPressed;
  final VoidCallback onAdminPressed;
  final Function(int) onPageSelected;
  final Function(int) onPageSwiped;
  final PageController pageController;
  final List<Widget> pages;
  final bool isLoggedIn;
  final bool isAdmin;
  final GlobalKey profileIconButtonKey;
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
    required this.profileIconButtonKey,
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
            top: MediaQuery.paddingOf(context).top + 2,
            left: 8,
            right: 8,
            child: ClipRRect(
              borderRadius: .circular(20),
              child: BackdropFilter(
                filter: .blur(sigmaX: 12, sigmaY: 8),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
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
                              onPressed: () =>
                                  onProfileIconPressed(Offset(0, 0)),
                              icon: Icon(Icons.account_circle_rounded),
                            )
                          : IconButton(
                              key: profileIconButtonKey,
                              onPressed: () {
                                final renderBox =
                                    profileIconButtonKey.currentContext
                                            ?.findRenderObject()
                                        as RenderBox?;
                                if (renderBox == null) {
                                  getIt<InnerLoggerHandler>().logInfo(
                                    message: 'Login Button Error',
                                  );
                                  Fluttertoast.showToast(
                                    msg: 'Login Button Error',
                                  );
                                  return;
                                }
                                final position = renderBox.localToGlobal(
                                  Offset.zero,
                                );
                                final centerOffset = Offset(
                                  position.dx + (renderBox.size.width / 2),
                                  position.dy + (renderBox.size.height / 2),
                                );
                                onProfileIconPressed(centerOffset);
                              },
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
                height: MediaQuery.paddingOf(context).top + inRadius - 4,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipPath(
        clipper: AppUpwardReveresClipper(radius: inRadius, isUpward: false),
        child: NavigationBar(
          selectedIndex: pageIndex,
          height: 64 + inRadius,
          onDestinationSelected: onPageSelected,
          backgroundColor: context.appColorScheme.surfaceContainerHigh,
          destinations: [
            Padding(
              padding: const EdgeInsets.only(top: inRadius),
              child: NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_filled),
                label: 'Home',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: inRadius),
              child: NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront),
                label: 'Store',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: inRadius),
              child: NavigationDestination(
                icon: Icon(Icons.message_outlined),
                selectedIcon: Icon(Icons.message_rounded),
                label: 'Ask',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: inRadius),
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
      ),
    );
  }
}
