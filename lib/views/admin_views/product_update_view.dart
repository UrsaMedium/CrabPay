import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductUpdateView extends StatefulWidget {
  const ProductUpdateView({super.key});

  @override
  State<ProductUpdateView> createState() => _ProductUpdateViewState();
}

class _ProductUpdateViewState extends State<ProductUpdateView> {
  List<Product>? _products;
  List<DropdownMenuEntry<Product>>? _productDropDownMenuEntries;
  final TextEditingController _productDropDownMenuController =
      TextEditingController();
  Product? _selectedProduct;
  final TextEditingController _imageNameController = TextEditingController();
  String _imageName = '';
  final TextEditingController _productNameController = TextEditingController();
  String _productName = '';
  final TextEditingController _descriptionController = TextEditingController();
  String _descriptionText = '';

  @override
  void dispose() {
    _productDropDownMenuController.dispose();
    _imageNameController.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<DatabaseBloc>().add(DatabaseEventFetchAllProductsForAdmin());
    _products = context.read<DatabaseBloc>().state.products;
    super.initState();
  }

  void reloadView(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ProductUpdateView(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  List<DropdownMenuEntry<Product>> _createProductDropDownMenuEntries() {
    List<DropdownMenuEntry<Product>> result = [];
    if (_products != null) {
      for (var product in _products!) {
        result.add(DropdownMenuEntry(value: product, label: product.name));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _productDropDownMenuEntries = _createProductDropDownMenuEntries();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownMenu<Product>(
                dropdownMenuEntries: _productDropDownMenuEntries!,
                controller: _productDropDownMenuController,
                enabled: _productDropDownMenuEntries!.isNotEmpty,
                // expandedInsets: EdgeInsets.zero,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 1,
                      color: context.appColorScheme.primary,
                    ),
                  ),
                ),
                enableSearch: true,
                onSelected: (value) => setState(() {
                  _selectedProduct = value;
                }),
                menuHeight: 432,
              ),
            ),
            _selectedProduct != null
                ? Flexible(
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            color: context.appColorScheme.primaryContainer,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Divider(),
                                      Text('Image name'),
                                      TextField(
                                        controller: _imageNameController,
                                        onChanged: (value) {
                                          _imageName = value.trim();
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Current image name: ${_selectedProduct!.image}',
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Divider(),
                                      Text('Product name'),
                                      TextField(
                                        controller: _productNameController,
                                        onChanged: (value) {
                                          _productName = value.trim();
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Current product name: ${_selectedProduct!.name}',
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Divider(),
                                      Text('Description'),
                                      TextField(
                                        controller: _descriptionController,
                                        onChanged: (value) {
                                          _descriptionText = value.trim();
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Current description: ${_selectedProduct!.description}',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text('Choose aproduct to madify'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _selectedProduct != null
                    ? () {
                        context.read<DatabaseBloc>().add(
                          DatabaseEventUpdateProduct(
                            productId: _selectedProduct!.id,
                            imageName: _imageName == '' ? null : _imageName,
                            productName: _productName == ''
                                ? null
                                : _productName,
                            description: _descriptionText == ''
                                ? null
                                : _descriptionText,
                          ),
                        );
                        reloadView(context);
                      }
                    : null,
                child: Text('Push the changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
