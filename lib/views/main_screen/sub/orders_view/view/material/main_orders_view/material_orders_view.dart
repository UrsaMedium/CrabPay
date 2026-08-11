import 'package:crabpay/core/custom_ui_elements/custom_faster_page_scroll_physics.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/cubit.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/main_orders_view/material_custom_orders_view_appbar.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/main_orders_view/material_custom_orders_view_page_bar.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/search/material_search_orders_page_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialOrdersView extends StatelessWidget {
  final VoidCallback onBackButtonPressed;
  final VoidCallback onLoadMore;
  final Function(String) onSupportSendMessagePressed;
  final PageController pageController;
  final Function(int) onPageSwiped;
  final Function(int) onPageSelected;
  final Function(BuildContext, int) pageBuilder;
  final VoidCallback changeSearchState;
  final VoidCallback onSearchBarPressed;
  const MaterialOrdersView({
    super.key,
    required this.onBackButtonPressed,
    required this.onSupportSendMessagePressed,
    required this.onLoadMore,
    required this.pageController,
    required this.onPageSwiped,
    required this.pageBuilder,
    required this.onPageSelected,
    required this.changeSearchState,
    required this.onSearchBarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isSearchOpen = context.select<OrdersViewCubit, bool>(
          (cubit) => cubit.state.isSerchOpen,
        );
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: MaterialCustomOrdersViewAppbar(
            onBackButtonPressed: onBackButtonPressed,
            changeSearchState: changeSearchState,
          ),
          body: AnimatedCrossFade(
            duration: const Duration(milliseconds: 350),
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeIn,
            crossFadeState: isSearchOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            secondChild: Stack(
              children: [
                pageBuilder(context, 2),
                Positioned(
                  top: MediaQuery.paddingOf(context).top * 2 + 12,
                  left: 8,
                  right: 8,
                  child: MaterialSearchOrdersPageSearchBar(
                    onSearchBarPressed: onSearchBarPressed,
                  ),
                ),
              ],
            ),
            firstChild: Stack(
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
            layoutBuilder:
                (topChild, topChildKey, bottomChild, bottomChildKey) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        key: bottomChildKey,
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: bottomChild,
                      ),
                      Positioned(
                        key: topChildKey,
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: topChild,
                      ),
                    ],
                  );
                },
          ),
        );
      },
    );
  }
}
