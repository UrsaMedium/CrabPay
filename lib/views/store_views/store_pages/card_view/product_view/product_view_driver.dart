import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/buy_bottom_sheet/buy_bottom_sheet.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/product_view/material_product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ProductViewDriver extends StatelessWidget {
  static const routeName = 'card-view';
  final String productId; //also tag identoty
  final String additionalSuffix; //tag identoty
  final String index; //tag identoty
  const ProductViewDriver({
    super.key,
    required this.productId,
    required this.additionalSuffix,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select(
      (AuthBloc bloc) => bloc.state.currentUser,
    );
    final isAdmin = currentUser.isAdmin;
    final isAnonymous = currentUser.isAnonymous;
    final userId = currentUser.id;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        !Navigator.of(context).canPop() ? context.go('/') : context.pop();
      },
      child: BlocBuilder<DatabaseBloc, DatabaseState>(
        builder: (context, dbState) {
          final theProduct = dbState.products
              ?.where((aProduct) => aProduct.id == productId)
              .firstOrNull;

          final isBeingLoaded = dbState.states == DatabaseStates.dbLoading;
          final userFavorites = dbState.userPreferences ?? [];
          final isFavorite = userFavorites.contains(productId);
          final productFields = dbState.productFields;
          final heroTag = 'card-hero-$productId-$additionalSuffix-$index';

          void onBackButtonPressed() {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          }

          void onAdminProductPanelPressed() {
            context.pushNamed(
              'update_product_admin_panel_view',
              pathParameters: {'productId': productId},
            );
          }

          void onFavoritePressed() {
            if (isAnonymous) {
              Fluttertoast.showToast(msg: 'Sign In');
              return;
            }
            if (isBeingLoaded) {
              Fluttertoast.showToast(msg: 'Please, wait');
              return;
            }
            if (isFavorite) {
              context.read<DatabaseBloc>().add(
                DatabaseEventDeleteUserPreference(
                  productId: productId,
                  userId: userId,
                ),
              );
            } else {
              context.read<DatabaseBloc>().add(
                DatabaseEventAddUserPreference(
                  userId: userId,
                  productId: productId,
                ),
              );
            }
          }

          Future<void> onBuyBottomSheetCalled() async {
            if (productFields != null) {
              await showModalBottomSheet(
                showDragHandle: false,
                useSafeArea: false,
                context: context,
                enableDrag: true,
                isScrollControlled: true,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerLow.withValues(alpha: .6),
                builder: (_) {
                  return Wrap(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow
                                .withValues(alpha: .5),
                          ),
                        ),
                        child: BuyBottomSheet(
                          productId: theProduct!.id,
                          productFields: productFields,
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              Fluttertoast.showToast(msg: 'No Fields! Error');
              context.read<DatabaseBloc>().add(
                DatabaseEventFetchProductFields(productId: productId),
              );
            }
          }

          return MaterialProductView(
            tag: heroTag,
            isAdmin: isAdmin,
            isFavorite: isFavorite,
            isFavoriteLoading: isBeingLoaded,
            isFieldsLoaded: productFields != null,
            onAdminProductPanelPressed: onAdminProductPanelPressed,
            onBackButtonPressed: onBackButtonPressed,
            onBuyBottomSheetCalled: onBuyBottomSheetCalled,
            onFavoritePressed: onFavoritePressed,
            product: theProduct,
          );
        },
      ),
    );
  }
}
