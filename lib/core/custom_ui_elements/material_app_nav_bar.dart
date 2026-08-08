import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialAppNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const MaterialAppNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<MaterialAppNavBar> createState() => _MaterialAppNavBarState();
}

class _MaterialAppNavBarState extends State<MaterialAppNavBar> {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _tab0Key = GlobalKey();
  final GlobalKey _tab1Key = GlobalKey();
  final GlobalKey _tab2Key = GlobalKey();
  final GlobalKey _tab3Key = GlobalKey();

  Offset? _tab0Position;
  Offset? _tab1Position;
  Offset? _tab2Position;
  Offset? _tab3Position;

  Size? _tab0Size;
  Size? _tab1Size;
  Size? _tab2Size;
  Size? _tab3Size;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extractPositions();
    });
    super.initState();
  }

  void _extractPositions() {
    final stackContext = _stackKey.currentContext;
    final tab0Context = _tab0Key.currentContext;
    final tab1Context = _tab1Key.currentContext;
    final tab2Context = _tab2Key.currentContext;
    final tab3Context = _tab3Key.currentContext;

    if (stackContext != null &&
        tab0Context != null &&
        tab2Context != null &&
        tab1Context != null &&
        tab3Context != null) {
      final stackRenderBox = stackContext.findRenderObject() as RenderBox;
      final tab0RenderBox = tab0Context.findRenderObject() as RenderBox;
      final tab1RenderBox = tab1Context.findRenderObject() as RenderBox;
      final tab2RenderBox = tab2Context.findRenderObject() as RenderBox;
      final tab3RenderBox = tab3Context.findRenderObject() as RenderBox;

      setState(() {
        _tab0Size = tab0RenderBox.size;
        _tab0Position = tab0RenderBox.localToGlobal(
          Offset.zero,
          ancestor: stackRenderBox,
        );
        _tab1Size = tab1RenderBox.size;
        _tab1Position = tab1RenderBox.localToGlobal(
          Offset.zero,
          ancestor: stackRenderBox,
        );
        _tab2Size = tab2RenderBox.size;
        _tab2Position = tab2RenderBox.localToGlobal(
          Offset.zero,
          ancestor: stackRenderBox,
        );
        _tab3Size = tab3RenderBox.size;
        _tab3Position = tab3RenderBox.localToGlobal(
          Offset.zero,
          ancestor: stackRenderBox,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Offset? activePosition;
    Size? activeSize;
    switch (widget.currentIndex) {
      case 0:
        activePosition = _tab0Position;
        activeSize = _tab0Size;
        break;
      case 1:
        activePosition = _tab1Position;
        activeSize = _tab1Size;
        break;
      case 2:
        activePosition = _tab2Position;
        activeSize = _tab2Size;
        break;
      case 3:
        activePosition = _tab3Position;
        activeSize = _tab3Size;
        break;
      default:
        activePosition = _tab0Position;
        activeSize = _tab0Size;
    }
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
          decoration: BoxDecoration(
            borderRadius: .circular(27),
          ),
          clipBehavior: .antiAlias,
          height: 56,
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
                borderRadius: .circular(27),
                border: .all(color: context.appColorScheme.outline),
                color: context.appColorScheme.surfaceContainerHighest
                    .withValues(alpha: context.highGraphics ? 0.4 : .97),
              ),
              child: Stack(
                key: _stackKey,
                children: [
                  if (activePosition != null && activeSize != null)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 250),
                      left: activePosition.dx,
                      top: activePosition.dy,
                      width: activeSize.width,
                      height: activeSize.height,
                      child: Container(
                        padding: .symmetric(horizontal: 16, vertical: 2),
                        decoration: BoxDecoration(
                          color: context.appColorScheme.secondaryContainer
                              .withValues(alpha: .8),
                          borderRadius: .circular(24),
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
                          key: _tab0Key,
                          icon: Icons.home_outlined,
                          isSelected: widget.currentIndex == 0,
                          onTap: () => widget.onTap(0),
                        ),
                        MaterialAppNavBarItem(
                          key: _tab1Key,
                          icon: Icons.storefront_outlined,
                          isSelected: widget.currentIndex == 1,
                          onTap: () => widget.onTap(1),
                        ),
                        MaterialAppNavBarItem(
                          key: _tab2Key,
                          icon: Icons.support_agent_outlined,
                          isSelected: widget.currentIndex == 2,
                          onTap: () => widget.onTap(2),
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
                                key: _tab3Key,
                                icon: Icons.shopping_cart_checkout_rounded,
                                isSelected: widget.currentIndex == 3,
                                onTap: () => widget.onTap(3),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
