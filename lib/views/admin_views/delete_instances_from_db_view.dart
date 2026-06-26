import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeleteInstancesFromDbView extends StatefulWidget {
  const DeleteInstancesFromDbView({super.key});

  @override
  State<DeleteInstancesFromDbView> createState() =>
      _DeleteInstancesFromDbViewState();
}

class _DeleteInstancesFromDbViewState extends State<DeleteInstancesFromDbView> {
  final TextEditingController _productControler = TextEditingController();
  Product? _choosenProduct;
  final TextEditingController _fieldControler = TextEditingController();
  final TextEditingController _cartItemControler = TextEditingController();
  List<DropdownMenuEntry<Product>> _productDropDownMenuEntries = [];

  @override
  void dispose() {
    _productControler.dispose();
    _fieldControler.dispose();
    _cartItemControler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<DatabaseBloc>().add(DatabaseEventFetchAllProductsForAdmin());
    super.initState();
  }

  List<DropdownMenuEntry<Product>> _products(BuildContext context) {
    List<DropdownMenuEntry<Product>> result = [];
    List<Product> products = context.read<DatabaseBloc>().state.products!;
    for (var product in products) {
      result.add(DropdownMenuEntry(value: product, label: product.name));
    }
    return result;
  }

  void _refreshData(BuildContext context) {
    setState(() {
      _productDropDownMenuEntries = _products(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    _refreshData(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        !Navigator.of(context).canPop() ? context.go('/ask') : context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                context.go('/ask');
              }
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Text('product'),
                  Row(
                    children: [
                      Flexible(
                        child: BlocBuilder<DatabaseBloc, DatabaseState>(
                          builder: (context, state) {
                            return DropdownMenu<Product>(
                              dropdownMenuEntries: _productDropDownMenuEntries,
                              controller: _productControler,
                              onSelected: (value) => setState(() {
                                _choosenProduct = value!;
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
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _choosenProduct != null
                              ? context.read<DatabaseBloc>().add(
                                  DatabaseEventDeleteProduct(
                                    product: _choosenProduct!,
                                  ),
                                )
                              : '';
                          context.read<DatabaseBloc>().add(
                            DatabaseEventFetchAllProductsForAdmin(),
                          );
                          _refreshData(context);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text('field'),
                  Row(
                    children: [
                      Flexible(child: TextField(controller: _fieldControler)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text('cartitem'),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(controller: _cartItemControler),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                            CartEventDeleteCartItemById(
                              cartItemId: _cartItemControler.text,
                            ),
                          );
                          _cartItemControler.clear();
                          setState(() {});
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
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
