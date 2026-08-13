import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/main_screen/sub/card_view/product_view/driver/cubit.dart';
import 'package:crabpay/views/main_screen/sub/card_view/product_view/view/material/material_product_view_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialProductView extends StatelessWidget {
  final String tag;
  final VoidCallback onBackButtonPressed;
  final VoidCallback onAdminProductPanelPressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback onBuyBottomSheetCalled;
  final Function(DragEndDetails) onVerticalSwipe;
  const MaterialProductView({
    super.key,
    required this.tag,
    required this.onBackButtonPressed,
    required this.onAdminProductPanelPressed,
    required this.onFavoritePressed,
    required this.onBuyBottomSheetCalled,
    required this.onVerticalSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColorScheme.surfaceContainerLowest,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MaterialProductViewAppbar(
        onBackButtonPressed: onBackButtonPressed,
        onAdminProductPanelPressed: onAdminProductPanelPressed,
        onFavoritePressed: onFavoritePressed,
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) => onVerticalSwipe(details),
        child: Builder(
          builder: (context) {
            final layer = context.select<ProductViewCubit, ProductViewLayers>(
              (cubit) => cubit.state.layer,
            );
            return Stack(
              children: [
                Column(
                  children: [
                    Hero(
                      tag: tag,
                      createRectTween: (begin, end) =>
                          MaterialRectArcTween(begin: begin, end: end),
                      child: ClipRRect(
                        borderRadius: .zero,
                        clipBehavior: .antiAlias,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://regred-rainbowbridge.ru/crabpay/images/products/${context.read<ProductViewCubit>().state.product!.image}.png',
                          width: MediaQuery.widthOf(context),
                          // height: MediaQuery.widthOf(context),
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) =>
                              Container(
                                color: context.appColorScheme.onInverseSurface,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.broken_image,
                                  color: context.appColorScheme.inversePrimary,
                                  size: 48,
                                ),
                              ),
                          placeholder: (context, url) => Container(
                            color: context.appColorScheme.onInverseSurface,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedPositioned(
                  top: ProductViewLayers.groundLayer != layer
                      ? kToolbarHeight + 40
                      : MediaQuery.widthOf(context) - 24,
                  left: 0,
                  right: 0,
                  bottom: 1,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.appColorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.only(
                        topLeft: .circular(24),
                        topRight: .circular(24),
                      ),
                    ),
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
                ),
                AnimatedPositioned(
                  top: ProductViewLayers.buyLayer == layer
                      ? kToolbarHeight + 80
                      : MediaQuery.heightOf(context) - 80,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.appColorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.only(
                        topLeft: .circular(24),
                        topRight: .circular(24),
                      ),
                    ),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


//  Column(
//             children: [
//               Expanded(
//                 child: CustomScrollView(
//                   shrinkWrap: true,
//                   slivers: [
//                     SliverToBoxAdapter(
//                       child: CachedNetworkImage(
//                         imageUrl:
//                             'https://regred-rainbowbridge.ru/crabpay/images/products/${product!.image}.png',
//                         width: double.infinity,
//                         height: 400,
//                         fit: BoxFit.cover,
//                         errorWidget: (context, error, stackTrace) => Container(
//                           color: context.appColorScheme.onInverseSurface,
//                           alignment: Alignment.center,
//                           child: Icon(
//                             Icons.broken_image,
//                             color: context.appColorScheme.inversePrimary,
//                             size: 48,
//                           ),
//                         ),
//                         placeholder: (context, url) => Container(
//                           color: context.appColorScheme.onInverseSurface,
//                           alignment: Alignment.center,
//                           child: const CircularProgressIndicator(),
//                         ),
//                       ),
//                     ),
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           product!.name,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: context.appColorScheme.primaryFixedDim,
//                             fontSize: 24,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SliverToBoxAdapter(
//                       child: Center(
//                         child: MarkdownBody(
//                           selectable: true,
//                           data: product!.description,
//                           builders: {'latex': LatexElementBuilder()},
//                           extensionSet: md.ExtensionSet(
//                             [LatexBlockSyntax()],
//                             [LatexInlineSyntax()],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: context.appColorScheme.primary,
//                   foregroundColor: context.appColorScheme.onPrimary,
//                 ),
//                 onPressed: onBuyBottomSheetCalled,
//                 child: isFieldsLoaded
//                     ? const Text("Ok, I'm ready to shop")
//                     : CircularProgressIndicator(
//                         color: context.appColorScheme.onPrimary,
//                       ),
//               ),
//             ],
//           ),