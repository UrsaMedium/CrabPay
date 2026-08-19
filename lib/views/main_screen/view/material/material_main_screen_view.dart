import 'package:crabpay/views/main_screen/view/material/material_app_nav_bar.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/custom_faster_page_scroll_physics.dart';
import 'package:crabpay/views/main_screen/view/material/material_main_screen_custom_app_bar.dart';
import 'package:flutter/material.dart';

class MaterialMainScreenView extends StatelessWidget {
  final VoidCallback onProfileIconPressed;
  final VoidCallback onOrdersPressed;
  final VoidCallback onAdminPressed;
  final Function(int) onPageSelected;
  final Function(int) onPageSwiped;
  final PageController pageController;
  final List<Widget> pages;
  const MaterialMainScreenView({
    super.key,
    required this.onProfileIconPressed,
    required this.onPageSelected,
    required this.pageController,
    required this.onPageSwiped,
    required this.pages,
    required this.onOrdersPressed,
    required this.onAdminPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MaterialMainScreenCustomAppBar(
        onAdminPressed: onAdminPressed,
        onOrdersPressed: onOrdersPressed,
        onProfileIconPressed: onProfileIconPressed,
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
      bottomNavigationBar: MaterialAppNavBar(onTap: onPageSelected),
    );
  }
}
