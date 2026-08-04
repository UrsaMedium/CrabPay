import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialAppNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const MaterialAppNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: .bottomCenter,
                end: .topCenter,
                colors: [
                  context.appColorScheme.surfaceContainerLowest,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: .circular(28)),
          clipBehavior: .antiAlias,
          height: 54,
          margin: .only(
            left: (MediaQuery.widthOf(context) - 308) / 2,
            right: (MediaQuery.widthOf(context) - 308) / 2,
            bottom: 8,
          ),
          child: BackdropFilter(
            enabled: context.highGraphics,
            filter: .blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: context.appColorScheme.surfaceContainerHighest
                    .withValues(alpha: context.highGraphics ? 0.4 : .97),
              ),
              child: Row(
                mainAxisAlignment: .center,
                spacing: 12,
                children: [
                  MaterialAppNavBarItem(
                    icon: Icons.home_outlined,
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  MaterialAppNavBarItem(
                    icon: Icons.storefront_outlined,
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  MaterialAppNavBarItem(
                    icon: Icons.support_agent_outlined,
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      final itemsCount = state.userCartItemAmount ?? 0;
                      return Badge(
                        alignment: .center,
                        offset: Offset(16, -20),
                        backgroundColor: context.appColorScheme.error,
                        textColor: context.appColorScheme.onError,
                        label: Text(
                          itemsCount > 0 ? itemsCount.toString() : '',
                        ),
                        isLabelVisible: itemsCount > 0,
                        child: MaterialAppNavBarItem(
                          icon: Icons.shopping_cart_checkout_rounded,
                          isSelected: currentIndex == 3,
                          onTap: () => onTap(3),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MaterialAppNavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final bool isSelected;
  final VoidCallback onTap;
  const MaterialAppNavBarItem({
    super.key,
    required this.icon,
    this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const .symmetric(horizontal: 19, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColorScheme.secondaryContainer.withValues(alpha: .8)
              : Colors.transparent,
          borderRadius: .circular(24),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? context.appColorScheme.primary
              : context.appColorScheme.onSurface,
          size: 28,
        ),
      ),
    );
  }
}
