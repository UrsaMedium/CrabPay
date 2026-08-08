import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialCustomOrdersViewPageBar extends StatefulWidget {
  final Function(int) onPageSelected;
  const MaterialCustomOrdersViewPageBar({
    super.key,
    required this.onPageSelected,
  });

  @override
  State<MaterialCustomOrdersViewPageBar> createState() =>
      _MaterialCustomOrdersViewPageBarState();
}

class _MaterialCustomOrdersViewPageBarState
    extends State<MaterialCustomOrdersViewPageBar> {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _tab0Key = GlobalKey();
  final GlobalKey _tab1Key = GlobalKey();

  Offset? _tab0Position;
  Size? _tab0Size;

  Offset? _tab1Position;
  Size? _tab1Size;

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

    if (stackContext != null && tab0Context != null && tab1Context != null) {
      final stackRenderBox = stackContext.findRenderObject() as RenderBox;
      final tab0RenderBox = tab0Context.findRenderObject() as RenderBox;
      final tab1RenderBox = tab1Context.findRenderObject() as RenderBox;

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = context.select<OrdersViewCubit, int>(
      (cubit) => cubit.state.page,
    );

    final activePosition = page == 0 ? _tab0Position : _tab1Position;
    final activeSize = page == 0 ? _tab0Size : _tab1Size;

    return Material(
      borderRadius: .circular(14),
      clipBehavior: .antiAlias,
      color: Colors.transparent,
      child: BackdropFilter(
        enabled: context.highGraphics,
        filter: .blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 36,
          // width: 46,
          decoration: BoxDecoration(
            color: context.appColorScheme.surfaceContainer.withValues(
              alpha: context.highGraphics ? .5 : .97,
            ),
          ),
          child: Stack(
            key: _stackKey,
            alignment: .center,
            children: [
              if (activePosition != null && activeSize != null)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  left: activePosition.dx - 16,
                  top: activePosition.dy - 2,
                  width: activeSize.width + 32,
                  height: activeSize.height + 4,
                  child: Container(
                    padding: .symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      color: context.appColorScheme.secondaryContainer
                          .withValues(alpha: .8),
                      borderRadius: .circular(16),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  GestureDetector(
                    key: _tab0Key,
                    onTap: () => widget.onPageSelected(0),
                    child: Text(
                      'Being Delivered',
                      style: TextStyle(
                        color: page == 0
                            ? context.appColorScheme.primary
                            : context.appColorScheme.onSurface,
                      ),
                    ),
                  ),
                  GestureDetector(
                    key: _tab1Key,
                    onTap: () => widget.onPageSelected(1),
                    child: Text(
                      'Delivered',
                      style: TextStyle(
                        color: page == 1
                            ? context.appColorScheme.primary
                            : context.appColorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
