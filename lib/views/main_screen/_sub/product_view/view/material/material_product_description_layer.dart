import 'package:crabpay/views/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/main_screen/_sub/product_view/driver/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;

class MaterialProductDescriptionLayer extends StatelessWidget {
  final Function(ScrollNotification) onScrollAction;
  final bool isPageReady;
  const MaterialProductDescriptionLayer({
    super.key,
    required this.onScrollAction,
    required this.isPageReady,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: context.read<ProductViewCubit>().state.descriptionLayerKey,
      decoration: BoxDecoration(
        color: context.appColorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.only(
          topLeft: .circular(24),
          topRight: .circular(24),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.read<ProductViewCubit>().state.product!.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.appColorScheme.primaryFixedDim,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isPageReady)
                  Align(
                    alignment: .topLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.heightOf(context) * .5,
                        minHeight: MediaQuery.heightOf(context) * .3,
                      ),
                      child: NotificationListener(
                        onNotification: (ScrollNotification notification) {
                          onScrollAction(notification);
                          return false;
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                '   Description',
                                style: TextStyle(fontWeight: .bold),
                              ),
                              MarkdownBody(
                                selectable: true,
                                data: context
                                    .read<ProductViewCubit>()
                                    .state
                                    .product!
                                    .description,
                                builders: {'latex': LatexElementBuilder()},
                                extensionSet: md.ExtensionSet(
                                  [LatexBlockSyntax()],
                                  [LatexInlineSyntax()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [
                context.appColorScheme.outline.withValues(alpha: .6),
                context.appColorScheme.outline.withValues(alpha: .3),
                Colors.transparent,
                Colors.transparent,
              ],
            ).createShader(bounds),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                borderRadius: .circular(22),
                border: .all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
