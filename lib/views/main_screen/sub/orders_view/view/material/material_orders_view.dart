import 'package:crabpay/core/custom_ui_elements/custom_faster_page_scroll_physics.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/material_custom_orders_view_appbar.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/material_custom_orders_view_page_bar.dart';
import 'package:flutter/material.dart';

class MaterialOrdersView extends StatelessWidget {
  final VoidCallback onBackButtonPressed;
  final VoidCallback onLoadMore;
  final Function(String) onSupportSendMessagePressed;
  final PageController pageController;
  final Function(int) onPageSwiped;
  final Function(int) onPageSelected;
  final Function(BuildContext, int) pageBuilder;
  const MaterialOrdersView({
    super.key,
    required this.onBackButtonPressed,
    required this.onSupportSendMessagePressed,
    required this.onLoadMore,
    required this.pageController,
    required this.onPageSwiped,
    required this.pageBuilder,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MaterialCustomOrdersViewAppbar(
        onBackButtonPressed: onBackButtonPressed,
      ),
      body: Stack(
        children: [
          PageView.builder(
            itemCount: 2,
            physics: const CustomFasterPageScrollPhysics(),
            controller: pageController,
            onPageChanged: onPageSwiped,
            itemBuilder: (context, index) => pageBuilder(context, index),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top * 2 + 12,
            left: 8,
            right: 8,
            child: MaterialCustomOrdersViewPageBar(
              onPageSelected: (index) => onPageSelected(index),
            ),
          ),
        ],
      ),
    );
  }
}
