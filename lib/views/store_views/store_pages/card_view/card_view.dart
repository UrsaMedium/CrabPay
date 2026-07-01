import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/buy_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' as md;

class CardView extends StatefulWidget {
  static const routeName = 'card-view';
  final String productId;
  final String additionalSuffix;
  const CardView({
    super.key,
    required this.productId,
    required this.additionalSuffix,
  });

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  late final AuthUser _currentUser;
  bool _isFavorite = false;
  List<ProductField>? _productFields;
  Product? _product;

  @override
  void initState() {
    dataPrefetching(context);
    super.initState();
  }

  Future<void> dataPrefetching(BuildContext context) async {
    context.read<DatabaseBloc>().add(
      DatabaseEventFetchProductFields(productId: widget.productId),
    );
    if (context.read<DatabaseBloc>().state.states ==
        DatabaseStates.productFieldsFetched) {
      _productFields = context.read<DatabaseBloc>().state.productFields;
    } else {
      _productFields = null;
    }
    _currentUser = context.read<AuthBloc>().state.currentUser ?? appTempUser;
    context.read<CartBloc>().add(
      CartEventFetchProductCartItemAmount(
        userId: _currentUser.id,
        productId: widget.productId,
      ),
    );
    _isFavorite =
        context.read<DatabaseBloc>().state.userPreferences?.any(
          (element) => element == widget.productId,
        ) ??
        false;
    _product = context.read<DatabaseBloc>().state.products?.firstWhere(
      (product) => product.id == widget.productId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _product == null
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
              tag: 'card-hero-${_product!.id}-${widget.additionalSuffix}',
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
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: IconButton(
                          iconSize: 32,
                          onPressed: () {
                            if (_isFavorite) {
                              context.read<DatabaseBloc>().add(
                                DatabaseEventDeleteUserPreference(
                                  productId: widget.productId,
                                  userId: _currentUser.id,
                                ),
                              );
                              setState(() {
                                _isFavorite = false;
                              });
                            } else {
                              context.read<DatabaseBloc>().add(
                                DatabaseEventAddUserPreference(
                                  productId: widget.productId,
                                  userId: _currentUser.id,
                                ),
                              );
                              setState(() {
                                _isFavorite = true;
                              });
                            }
                          },
                          icon: !_isFavorite
                              ? Icon(Icons.favorite_border_rounded)
                              : Icon(Icons.favorite_rounded, color: Colors.red),
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
                                    'http://regred-rainbowbridge.ru/crabpay/images/products/${_product!.image}.png',
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
                                  _product!.name,
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
                                  data: _product!.description,
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
                            current.states ==
                                DatabaseStates.productFieldsFetched ||
                            current.states ==
                                DatabaseStates.productFieldsNotFetched,
                        builder: (context, state) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.appColorScheme.primary,
                              foregroundColor: context.appColorScheme.onPrimary,
                            ),
                            onPressed: () async {
                              if (_productFields != null) {
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
                                            productId: _product!.id,
                                            productFields: _productFields!,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                _productFields = state.productFields;
                                if (_productFields == null) {
                                  Fluttertoast.showToast(
                                    msg: 'No Fields! Something went wrong.',
                                  );
                                  context.read<DatabaseBloc>().add(
                                    DatabaseEventFetchProductFields(
                                      productId: widget.productId,
                                    ),
                                  );
                                }
                              }
                            },
                            child:
                                state.states ==
                                    DatabaseStates.productFieldsFetched
                                ? Text('Ok, I\'am ready to shop')
                                : state.states ==
                                      DatabaseStates.productFieldsNotFetched
                                ? Text('No fields. Tap to try again')
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
