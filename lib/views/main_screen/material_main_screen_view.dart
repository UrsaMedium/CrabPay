import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/custom_ui_elements/material_app_nav_bar.dart';
import 'package:crabpay/core/custom_ui_elements/custom_faster_page_scroll_physics.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MaterialMainScreenView extends StatelessWidget {
  final int itemsCount;
  final int pageIndex;
  final Function(Offset) onProfileIconPressed;
  final VoidCallback onPurchasesPressed;
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
    required this.onPurchasesPressed,
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
          PageView.builder(
            itemCount: pages.length,
            physics: const CustomFasterPageScrollPhysics(),
            controller: pageController,
            onPageChanged: onPageSwiped,
            itemBuilder: (context, index) {
              return pages[index];
            },
          ),
          Container(
            height: MediaQuery.paddingOf(context).top * 2 + 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: .topCenter,
                end: .bottomCenter,
                colors: [Colors.black, Colors.transparent],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 2,
            left: 8,
            right: 8,
            child: Material(
              borderRadius: .circular(24),
              clipBehavior: .antiAlias,
              color: Colors.transparent,
              child: BackdropFilter(
                enabled: context.highGraphics,
                filter: .blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: context.appColorScheme.surfaceContainer.withValues(
                      alpha: context.highGraphics ? .5 : .97,
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
                          onPressed: onPurchasesPressed,
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
        ],
      ),
      bottomNavigationBar: MaterialAppNavBar(
        currentIndex: pageIndex,
        onTap: onPageSelected,
      ),
    );
  }
}