import 'package:crabpay/views/custom_ui_elements/material_app_nav_bar.dart';
import 'package:crabpay/views/custom_ui_elements/custom_faster_page_scroll_physics.dart';
import 'package:crabpay/views/main_screen/view/material_main_screen_custom_app_bar.dart';
import 'package:flutter/material.dart';

class MaterialMainScreenView extends StatelessWidget {
  final int itemsCount;
  final int pageIndex;
  final Function(Offset) onProfileIconPressed;
  final VoidCallback onOrdersPressed;
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
    required this.onOrdersPressed,
    required this.onAdminPressed,
    required this.isAdmin,
    required this.profileIconButtonKey,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MaterialMainScreenCustomAppBar(
        isAdmin: isAdmin,
        isLoggedIn: isLoggedIn,
        onAdminPressed: onAdminPressed,
        onOrdersPressed: onOrdersPressed,
        onProfileIconPressed: onProfileIconPressed,
        profileIconButtonKey: profileIconButtonKey,
      ),
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
        ],
      ),
      bottomNavigationBar: MaterialAppNavBar(
        currentIndex: pageIndex,
        onTap: onPageSelected,
      ),
    );
  }
}
