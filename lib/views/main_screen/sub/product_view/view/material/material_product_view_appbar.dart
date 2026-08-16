import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/main_screen/sub/product_view/driver/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialProductViewAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;
  final VoidCallback onBackButtonPressed;
  final VoidCallback onAdminProductPanelPressed;
  final VoidCallback onFavoritePressed;
  const MaterialProductViewAppbar({
    super.key,
    this.height = kToolbarHeight,
    required this.onBackButtonPressed,
    required this.onAdminProductPanelPressed,
    required this.onFavoritePressed,
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
          child: Builder(
            builder: (context) {
              return Row(
                mainAxisAlignment: .spaceBetween,
                mainAxisSize: .max,
                spacing: 4,
                children: [
                  Stack(
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
                            width: 46,
                            decoration: BoxDecoration(
                              color: context.appColorScheme.surfaceContainerHigh
                                  .withValues(
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
                      IgnorePointer(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: .topCenter,
                            end: .bottomCenter,
                            colors: [
                              context.appColorScheme.outline.withValues(
                                alpha: .2,
                              ),
                              context.appColorScheme.outline.withValues(
                                alpha: .1,
                              ),
                              Colors.transparent,
                              Colors.transparent,
                              context.appColorScheme.outline.withValues(
                                alpha: .1,
                              ),
                            ],
                          ).createShader(bounds),
                          child: Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              borderRadius: .circular(22),
                              border: .all(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      if (context.read<ProductViewCubit>().state.isAdmin)
                        Stack(
                          children: [
                            Material(
                              borderRadius: .circular(24),
                              clipBehavior: .antiAlias,
                              color: Colors.transparent,
                              child: BackdropFilter(
                                enabled: context.highGraphics,
                                filter: .blur(sigmaX: 12, sigmaY: 12),
                                child: Container(
                                  alignment: .centerEnd,
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                    color: context
                                        .appColorScheme
                                        .surfaceContainerHigh
                                        .withValues(
                                          alpha: context.highGraphics
                                              ? .5
                                              : .97,
                                        ),
                                  ),
                                  child: IconButton(
                                    onPressed: onAdminProductPanelPressed,
                                    icon: const Icon(Icons.settings),
                                    color:
                                        context.appColorScheme.errorContainer,
                                  ),
                                ),
                              ),
                            ),
                            IgnorePointer(
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: .topCenter,
                                  end: .bottomCenter,
                                  colors: [
                                    context.appColorScheme.outline.withValues(
                                      alpha: .2,
                                    ),
                                    context.appColorScheme.outline.withValues(
                                      alpha: .1,
                                    ),
                                    Colors.transparent,
                                    Colors.transparent,
                                    context.appColorScheme.outline.withValues(
                                      alpha: .1,
                                    ),
                                  ],
                                ).createShader(bounds),
                                child: Container(
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                    borderRadius: .circular(22),
                                    border: .all(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Stack(
                        children: [
                          Material(
                            borderRadius: .circular(24),
                            clipBehavior: .antiAlias,
                            color: Colors.transparent,
                            child: BackdropFilter(
                              enabled: context.highGraphics,
                              filter: .blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                alignment: .centerEnd,
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  color: context
                                      .appColorScheme
                                      .surfaceContainerHigh
                                      .withValues(
                                        alpha: context.highGraphics ? .5 : .97,
                                      ),
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final isFavoriteLoading = context
                                        .select<ProductViewCubit, bool>(
                                          (cubit) =>
                                              cubit.state.isFavoriteLoading,
                                        );
                                    final isFavorite = context
                                        .select<ProductViewCubit, bool>(
                                          (cubit) => cubit.state.isFavorite,
                                        );
                                    return IconButton(
                                      iconSize: 32,
                                      onPressed: onFavoritePressed,
                                      icon: isFavoriteLoading
                                          ? const CircularProgressIndicator()
                                          : Icon(
                                              isFavorite
                                                  ? Icons.favorite_rounded
                                                  : Icons
                                                        .favorite_border_rounded,
                                              color: isFavorite
                                                  ? Colors.red
                                                  : null,
                                            ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          IgnorePointer(
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                begin: .topCenter,
                                end: .bottomCenter,
                                colors: [
                                  context.appColorScheme.outline.withValues(
                                    alpha: .2,
                                  ),
                                  context.appColorScheme.outline.withValues(
                                    alpha: .1,
                                  ),
                                  Colors.transparent,
                                  Colors.transparent,
                                  context.appColorScheme.outline.withValues(
                                    alpha: .1,
                                  ),
                                ],
                              ).createShader(bounds),
                              child: Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  borderRadius: .circular(22),
                                  border: .all(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
