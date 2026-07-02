import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/buy_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' as md;

class CardView extends StatelessWidget {
  static const routeName = 'card-view';
  final String productId; //also tag identoty
  final String additionalSuffix; //tag identoty
  final String index; //tag identoty
  const CardView({
    super.key,
    required this.productId,
    required this.additionalSuffix,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final product = context.read<DatabaseBloc>().state.products?.firstWhere(
      (product) => product.id == productId,
    );
    final currentUser =
        context.read<AuthBloc>().state.currentUser ?? appTempUser;
    List<ProductField>? productFields;
    return product == null
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    context.pop();
                  }
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            body: Center(child: Text('Something went wrong')),
          )
        : PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }
              !Navigator.of(context).canPop() ? context.go('/') : context.pop();
            },
            child: Hero(
              tag: 'card-hero-${product.id}-$additionalSuffix-$index',
              createRectTween: (begin, end) =>
                  MaterialRectArcTween(begin: begin, end: end),
              child: ClipRRect(
                borderRadius: .zero,
                clipBehavior: .antiAlias,
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        if (GoRouter.of(context).canPop()) {
                          context.pop();
                        }
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          context.pushNamed(
                            'product_update_view',
                            pathParameters: {'productId': productId},
                          );
                        },
                        icon: Icon(Icons.settings),
                        color: context.appColorScheme.errorContainer,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: BlocBuilder<DatabaseBloc, DatabaseState>(
                          builder: (context, state) {
                            final bool beingLoaded =
                                state.states ==
                                DatabaseStates.userPreferencesBeingLoaded;
                            final userFavorites = context
                                .read<DatabaseBloc>()
                                .state
                                .userPreferences;
                            bool isFavorite =
                                userFavorites?.any(
                                  (favorite) => favorite == productId,
                                ) ??
                                false;
                            return IconButton(
                              iconSize: 32,
                              onPressed: () {
                                if (beingLoaded) {
                                  Fluttertoast.showToast(msg: 'Please, wait');
                                } else {
                                  if (isFavorite) {
                                    context.read<DatabaseBloc>().add(
                                      DatabaseEventDeleteUserPreference(
                                        productId: productId,
                                        userId: currentUser.id,
                                      ),
                                    );
                                  } else {
                                    context.read<DatabaseBloc>().add(
                                      DatabaseEventAddUserPreference(
                                        productId: productId,
                                        userId: currentUser.id,
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: beingLoaded
                                  ? CircularProgressIndicator()
                                  : !isFavorite
                                  ? Icon(Icons.favorite_border_rounded)
                                  : Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.red,
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          shrinkWrap: true,
                          slivers: [
                            SliverToBoxAdapter(
                              child: CachedNetworkImage(
                                imageUrl:
                                    'http://regred-rainbowbridge.ru/crabpay/images/products/${product.image}.png',
                                width: double.infinity,
                                height: 400,
                                fit: .cover,
                                errorWidget: (context, error, stackTrace) =>
                                    Container(
                                      color: context
                                          .appColorScheme
                                          .onInverseSurface,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.broken_image,
                                        color: context
                                            .appColorScheme
                                            .inversePrimary,
                                        size: 48,
                                      ),
                                    ),
                                placeholder: (context, url) => Container(
                                  color:
                                      context.appColorScheme.onInverseSurface,
                                  alignment: .center,
                                  child: const CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.name,
                                  textAlign: .center,
                                  style: TextStyle(
                                    color:
                                        context.appColorScheme.primaryFixedDim,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Center(
                                child: MarkdownBody(
                                  selectable: true,
                                  data: product.description,
                                  builders: {'latex': LatexElementBuilder()},
                                  extensionSet: md.ExtensionSet(
                                    [LatexBlockSyntax()],
                                    [LatexInlineSyntax()],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<DatabaseBloc, DatabaseState>(
                        buildWhen: (previous, current) =>
                            current.productFields != null,
                        builder: (context, state) {
                          productFields = context
                              .read<DatabaseBloc>()
                              .state
                              .productFields;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.appColorScheme.primary,
                              foregroundColor: context.appColorScheme.onPrimary,
                            ),
                            onPressed: () async {
                              if (productFields != null) {
                                await showModalBottomSheet(
                                  showDragHandle: false,
                                  useSafeArea: false,
                                  context: context,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  backgroundColor: context
                                      .appColorScheme
                                      .surfaceContainerLow
                                      .withValues(alpha: .6),
                                  builder: (BuildContext context) {
                                    return Wrap(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: .only(
                                              topLeft: Radius.circular(40),
                                              topRight: Radius.circular(40),
                                            ),
                                            border: .all(
                                              color: context
                                                  .appColorScheme
                                                  .surfaceContainerLow
                                                  .withValues(alpha: .5),
                                            ),
                                          ),
                                          child: BuyBottomSheet(
                                            productId: product.id,
                                            productFields: productFields!,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'No Fields! Something went wrong.',
                                );
                                context.read<DatabaseBloc>().add(
                                  DatabaseEventFetchProductFields(
                                    productId: productId,
                                  ),
                                );
                              }
                            },
                            child: productFields != null
                                ? Text('Ok, I\'am ready to shop')
                                : CircularProgressIndicator(
                                    color: context.appColorScheme.onPrimary,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
