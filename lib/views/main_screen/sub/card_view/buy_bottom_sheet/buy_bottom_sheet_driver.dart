import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/views/main_screen/sub/card_view/buy_bottom_sheet/buy_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class BuyBottomSheetDriver extends StatefulWidget {
  final Product product;
  final List<ProductField> productFields;
  const BuyBottomSheetDriver({
    super.key,
    required this.product,
    required this.productFields,
  });

  @override
  State<BuyBottomSheetDriver> createState() => _BuyBottomSheetDriverState();
}

class _BuyBottomSheetDriverState extends State<BuyBottomSheetDriver> {
  late int itemCounter;
  late final ProductField? imageField;
  bool intialStateSet = false;
  @override
  void initState() {
    imageField = widget.productFields
        .where((field) => field.isPriceImage)
        .firstOrNull;
    itemCounter = context.read<CartBloc>().state.productCartItemAmount ?? 0;
    super.initState();
  }

  void _onResetImageFieldPressed() {
    context.pushNamed(
      'reset_price_image_field_admin_panel_view',
      pathParameters: {'productId': widget.product.id},
    );
  }

  void _onAddFieldPressed() {
    context.pushNamed(
      'add_field_admin_panel_view',
      pathParameters: {'productId': widget.product.id},
    );
  }

  void _onDeleteLastAddedItem(BuildContext context) {
    try {
      if (itemCounter > 0) {
        context.read<CartBloc>().add(
          CartEventDeleteLastAddedProductCartItem(
            userId: context.read<AuthBloc>().state.currentUser.id,
            productId: widget.product.id,
          ),
        );
        setState(() {
          itemCounter--;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete');
      print('Failed to delete last cart item::: $e');
    }
  }

  void _onAddCartItemPressed(BuildContext context) {
    if (context.read<BuyBottomSheetCubit>().state.isEveryFieldSatisfied) {
      CartItem cartItem = CartItem(
        id: 'id',
        userId: context.read<AuthBloc>().state.currentUser.id,
        userName:
            context.read<AuthBloc>().state.currentUser.email ??
            'AnonUser-id:${context.read<AuthBloc>().state.currentUser.id}',
        productId: widget.product.id,
        productName: widget.product.name,
        purchaseData: context.read<BuyBottomSheetCubit>().state.retrievedData!,
        currency: 'rubDefoult',
        checkoutPrice: context
            .read<BuyBottomSheetCubit>()
            .state
            .precalculatedPrice,
        status: 'created',
      );
      try {
        context.read<CartBloc>().add(
          CartEventAddCartItem(
            cartItem: cartItem,
            userId: context.read<AuthBloc>().state.currentUser.id,
          ),
        );
        Fluttertoast.showToast(msg: 'It\'s in your cart now');
        setState(() {
          itemCounter++;
        });
      } on Exception catch (e) {
        Fluttertoast.showToast(msg: 'Failed to add to your cart');
        print('Failed to add to your cart: $e');
      }
    } else {
      Fluttertoast.showToast(msg: 'Every field must be filled');
    }
  }

  void _onCartIconPressed(BuildContext cuntext) {
    context.go('/cart');
  }

  void _onUserInput({
    required BuildContext context,
    required String fieldName,
    required String dataReceived,
  }) {
    context.read<BuyBottomSheetCubit>()._onBottomSheetDataRetrieved(
      fieldName: fieldName,
      dataReceived: dataReceived,
      imageField: imageField!,
      amountOfRequiredFields: widget.productFields.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BuyBottomSheetCubit(),
      child: BlocBuilder<BuyBottomSheetCubit, BuyBottomSheetState>(
        builder: (context, viewState) {
          return MaterialBuyBottomSheet(
            haveImageField: imageField != null,
            isAdmin: context.read<AuthBloc>().state.currentUser.isAdmin,
            isEveryFieldSatisfied: viewState.isEveryFieldSatisfied,
            itemsCount: itemCounter,
            onAddCartItemPressed: () => _onAddCartItemPressed(context),
            onAddFieldPressed: _onAddFieldPressed,
            onCartIconPressed: () => _onCartIconPressed(context),
            onDeleteLastAddedItem: () => _onDeleteLastAddedItem(context),
            onResetImageFieldPressed: () => _onResetImageFieldPressed(),
            onUserInput: (p0, p1) =>
                _onUserInput(context: context, fieldName: p0, dataReceived: p1),
            precalculatedPrice: viewState.precalculatedPrice,
            product: widget.product,
            productFields: widget.productFields,
          );
        },
      ),
    );
  }
}

class BuyBottomSheetState {
  final bool isEveryFieldSatisfied;
  final Map<String, String>? retrievedData;
  final double precalculatedPrice;

  BuyBottomSheetState({
    this.isEveryFieldSatisfied = false,
    this.retrievedData,
    this.precalculatedPrice = 0,
  });

  BuyBottomSheetState copyWith({
    bool? isEveryFieldSatisfied,
    int? itemsCount,
    Map<String, String>? retrievedData,
    double? precalculatedPrice,
    bool? isAdmin,
  }) {
    return BuyBottomSheetState(
      isEveryFieldSatisfied:
          isEveryFieldSatisfied ?? this.isEveryFieldSatisfied,
      retrievedData: retrievedData ?? this.retrievedData,
      precalculatedPrice: precalculatedPrice ?? this.precalculatedPrice,
    );
  }
}

class BuyBottomSheetCubit extends Cubit<BuyBottomSheetState> {
  BuyBottomSheetCubit() : super(BuyBottomSheetState());

  void _onBottomSheetDataRetrieved({
    required String fieldName,
    required String dataReceived,
    required ProductField imageField,
    required int amountOfRequiredFields,
  }) {
    Map<String, String> retrievedData = state.retrievedData ?? {};
    retrievedData[fieldName] = dataReceived;
    double precalculatedPrice = 0;
    if (imageField.handler == 'InputField') {
      final dataFromImageField =
          double.tryParse(retrievedData[imageField.fieldName] ?? '0') ?? 0;
      final imageCoefficient =
          imageField.priceImages?[imageField.fieldName] ?? 0;
      precalculatedPrice = dataFromImageField * imageCoefficient;
    } else {
      final dataFromImageField = retrievedData[imageField.fieldName];
      precalculatedPrice = imageField.priceImages?[dataFromImageField] ?? 0;
    }

    bool isEveryFieldSatisfied =
        (retrievedData.length == amountOfRequiredFields);
    if (isEveryFieldSatisfied) {
      for (var field in retrievedData.keys) {
        if (retrievedData[field]?.isEmpty ?? true) {
          isEveryFieldSatisfied = false;
          break;
        }
      }
    }
    if (precalculatedPrice == 0) {
      isEveryFieldSatisfied = false;
    }
    emit(
      BuyBottomSheetState().copyWith(
        isEveryFieldSatisfied: isEveryFieldSatisfied,
        precalculatedPrice: precalculatedPrice,
        retrievedData: retrievedData,
      ),
    );
  }
}
