import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const AppNavBar({super.key, required this.currentIndex, required this.onTap});

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
                  AppNavBarItem(
                    icon: Icons.home_outlined,
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  AppNavBarItem(
                    icon: Icons.storefront_outlined,
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  AppNavBarItem(
                    icon: Icons.support_agent_outlined,
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  AppNavBarItem(
                    icon: Icons.shopping_cart_checkout_rounded,
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
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

class AppNavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final bool isSelected;
  final VoidCallback onTap;
  const AppNavBarItem({
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
              ? context.appColorScheme.primaryContainer.withValues(alpha: .5)
              : Colors.transparent,
          borderRadius: .circular(24),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? context.appColorScheme.primary
              : context.appColorScheme.onPrimaryContainer,
          size: 28,
        ),
      ),
    );
  }
}
