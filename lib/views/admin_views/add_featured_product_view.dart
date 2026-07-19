import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AddFeaturedProductView extends StatefulWidget {
  const AddFeaturedProductView({super.key});

  @override
  State<AddFeaturedProductView> createState() => _AddFeaturedProductViewState();
}

class _AddFeaturedProductViewState extends State<AddFeaturedProductView> {
  final TextEditingController _suggestionInputController =
      TextEditingController();
  List<Product>? products;
  Product? _product;

  @override
  void initState() {
    products = context.read<DatabaseBloc>().state.products;
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'AddFeaturedProductView initState: products: $products',
    );
    super.initState();
  }

  @override
  void dispose() {
    _suggestionInputController.dispose();
    super.dispose();
  }

  List<DropdownMenuEntry<Product>> _products(BuildContext context) {
    List<DropdownMenuEntry<Product>> result = [];
    List<Product> products = context.read<DatabaseBloc>().state.products!;
    for (var product in products) {
      result.add(DropdownMenuEntry(value: product, label: product.name));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        getIt<InnerLoggerHandler>().logBreadcrumb(
          message: 'AddFeaturedProductView onPopInvokedWithResult',
          data: {'didPop': didPop, 'result': result},
        );
        if (didPop) return;
        !Navigator.of(context).canPop() ? context.go('/ask') : context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              getIt<InnerLoggerHandler>().logBreadcrumb(
                message: 'AddFeaturedProductView onBackButtonPressed',
              );
              if (GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                context.go('/ask');
              }
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            DropdownMenu<Product>(
              dropdownMenuEntries: _products(context),
              controller: _suggestionInputController,
              onSelected: (value) => setState(() {
                _product = value;
              }),
              expandedInsets: EdgeInsets.zero,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: context.appColorScheme.primary,
                    width: 1,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                getIt<InnerLoggerHandler>().logBreadcrumb(
                  message: 'AddFeaturedProductView: onPressed: Add Featured Product button pressed',
                  data: {'product': _product},
                );
                if (_product != null) {
                  context.read<DatabaseBloc>().add(
                    DatabaseEventAddFeaturedProduct(product: _product!),
                  );
                  // Fluttertoast.showToast(msg: '$_productId');
                } else {
                  Fluttertoast.showToast(msg: 'wrong input');
                }
              },
              child: Text('Add The Featured Product Id'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_product != null) {
                  context.read<DatabaseBloc>().add(
                    DatabaseEventDeleteFeaturedProduct(product: _product!),
                  );
                  // Fluttertoast.showToast(msg: '$_productId');
                } else {
                  Fluttertoast.showToast(msg: 'wrong input');
                }
              },
              child: Text('Delete The Featured Product Id'),
            ),
          ],
        ),
      ),
    );
  }
}
