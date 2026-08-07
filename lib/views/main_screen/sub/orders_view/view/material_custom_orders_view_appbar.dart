import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:flutter/material.dart';

class MaterialCustomOrdersViewAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;
  final VoidCallback onBackButtonPressed;
  const MaterialCustomOrdersViewAppbar({
    super.key,
    this.height = kToolbarHeight,
    required this.onBackButtonPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top,
            left: 8,
            right: 8,
          ),
          child: Row(
            spacing: 4,
            children: [
              Material(
                borderRadius: .circular(24),
                clipBehavior: .antiAlias,
                color: Colors.transparent,
                child: BackdropFilter(
                  enabled: context.highGraphics,
                  filter: .blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    height: 46,
                    // width: 46,
                    decoration: BoxDecoration(
                      color: context.appColorScheme.surfaceContainer.withValues(
                        alpha: context.highGraphics ? .5 : .97,
                      ),
                    ),
                    child: IconButton(
                      onPressed: onBackButtonPressed,
                      icon: Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  borderRadius: .circular(24),
                  clipBehavior: .antiAlias,
                  color: Colors.transparent,
                  child: BackdropFilter(
                    enabled: context.highGraphics,
                    filter: .blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: .symmetric(horizontal: 16),
                      height: 46,
                      // width: 46,
                      decoration: BoxDecoration(
                        color: context.appColorScheme.surfaceContainer
                            .withValues(alpha: context.highGraphics ? .5 : .97),
                      ),
                      child: Align(
                        alignment: .centerLeft,
                        child: Text(
                          'Orders',
                          style: TextStyle(
                            color: context.appColorScheme.primary,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Material(
                borderRadius: .circular(24),
                clipBehavior: .antiAlias,
                color: Colors.transparent,
                child: BackdropFilter(
                  enabled: context.highGraphics,
                  filter: .blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    height: 46,
                    // width: 46,
                    decoration: BoxDecoration(
                      color: context.appColorScheme.surfaceContainer.withValues(
                        alpha: context.highGraphics ? .5 : .97,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search_rounded),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
