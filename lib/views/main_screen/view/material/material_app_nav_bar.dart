import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/views/main_screen/driver/main_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialAppNavBar extends StatelessWidget {
  final Function(int) onTap;
  const MaterialAppNavBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select<MainScreenCubit, int>(
      (cubit) => cubit.state.page,
    );
    final double alignmentByX = -1 + (currentIndex * (2 / 3));
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
                colors: [Colors.black, Colors.transparent],
              ),
            ),
          ),
        ),
        Container(
          height: 56,
          margin: .only(
            left: (MediaQuery.widthOf(context) - 308) / 2,
            right: (MediaQuery.widthOf(context) - 308) / 2,
            bottom: 8,
          ),
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  final highGraphics = context.select<GlobalGraphicBloc, bool>(
                    (bloc) => bloc.state.highGraphics,
                  );
                  return Material(
                    borderRadius: .circular(27),
                    clipBehavior: .antiAlias,
                    color: Colors.transparent,
                    child: BackdropFilter(
                      enabled: highGraphics,
                      filter: .blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        color: context.appColorScheme.surfaceContainerHighest
                            .withValues(alpha: highGraphics ? 0.4 : .97),
                      ),
                    ),
                  );
                },
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: .topCenter,
                  end: .bottomCenter,
                  colors: [
                    context.appColorScheme.outline.withValues(alpha: .2),
                    context.appColorScheme.outline.withValues(alpha: .1),
                    Colors.transparent,
                    Colors.transparent,
                    context.appColorScheme.outline.withValues(alpha: .1),
                  ],
                ).createShader(bounds),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: .circular(27),
                    border: .all(color: Colors.white),
                  ),
                ),
              ),
              Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    alignment: Alignment(alignmentByX, 0),
                    child: FractionallySizedBox(
                      widthFactor: .25,
                      heightFactor: 1,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 4,
                          right: 4,
                          top: 4,
                          bottom: 4,
                        ),
                        decoration: BoxDecoration(
                          color: context.appColorScheme.secondaryContainer
                              .withValues(alpha: .8),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const .only(top: 3),
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
                        Builder(
                          builder: (context) {
                            final itemsCount = context
                                .select<MainScreenCubit, int>(
                                  (cubit) => cubit.state.userCartItemAmount,
                                );
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
                ],
              ),
            ],
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
      child: Container(
        padding: const .symmetric(horizontal: 19, vertical: 10),
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
