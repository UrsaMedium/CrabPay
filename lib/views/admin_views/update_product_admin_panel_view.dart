import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/dialogs/on_database_item_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class UpdateProductAdminPanelView extends StatefulWidget {
  static const routeName = 'update_product_admin_panel_view';
  final String? productId;
  const UpdateProductAdminPanelView({super.key, required this.productId});

  @override
  State<UpdateProductAdminPanelView> createState() => _UpdateProductAdminPanelViewState();
}

class _UpdateProductAdminPanelViewState extends State<UpdateProductAdminPanelView> {
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
  bool _ignoreStates = true;

  @override
  void initState() {
    _products = context.read<DatabaseBloc>().state.products;
    if (widget.productId != null && _products != null) {
      _selectedProduct = _products!.firstWhere(
        (product) => product.id == widget.productId,
      );
      _productDropDownMenuController.text = _selectedProduct?.name ?? '';
    }
    _productDropDownMenuEntries = _createProductDropDownMenuEntries();
    super.initState();
  }

  @override
  void dispose() {
    _productDropDownMenuController.dispose();
    _imageNameController.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetPage() {
    _productDropDownMenuController.clear();
    _imageNameController.clear();
    _productNameController.clear();
    _descriptionController.clear();
    _descriptionText = '';
    _productName = '';
    _imageName = '';
    _selectedProduct = null;
    _productDropDownMenuEntries = null;
    //
    _products = context.read<DatabaseBloc>().state.products;
    _productDropDownMenuEntries = _createProductDropDownMenuEntries();
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
          title: Text('Admin Panel'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: BlocBuilder<DatabaseBloc, DatabaseState>(
                builder: (context, state) {
                  final bool beingLoaded =
                      state.states == DatabaseStates.productsBeingLoaded;
                  return Row(
                    children: [
                      Text(_selectedProduct != null ? 'Delete' : ''),
                      IconButton(
                        iconSize: 32,
                        onPressed: _selectedProduct != null
                            ? () async {
                                if (beingLoaded) {
                                  Fluttertoast.showToast(msg: 'Please, wait');
                                } else {
                                  final delete =
                                      await showOnDatabaseItemDelete(context) ??
                                      false;
                                  if (delete && context.mounted) {
                                    Fluttertoast.showToast(msg: 'Deleting');
                                    context.read<DatabaseBloc>().add(
                                      DatabaseEventDeleteProduct(
                                        product: _selectedProduct!,
                                      ),
                                    );
                                  } else {
                                    Fluttertoast.showToast(msg: 'Phew');
                                  }
                                }
                              }
                            : null,
                        icon: beingLoaded
                            ? CircularProgressIndicator()
                            : Icon(
                                Icons.delete_forever_rounded,
                                color: _selectedProduct != null
                                    ? context.appColorScheme.errorContainer
                                    : Colors.transparent,
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<DatabaseBloc, DatabaseState>(
          builder: (context, state) {
            if (!_ignoreStates) {
              if (state.states == DatabaseStates.productsNotUpdated) {
                _ignoreStates = true;
                Fluttertoast.showToast(msg: 'Failed to update');
              } else if (state.states == DatabaseStates.productsUpdated) {
                context.read<DatabaseBloc>().add(
                  DatabaseEventFetchAllProducts(),
                );
              } else if (state.states == DatabaseStates.productsFetched) {
                _ignoreStates = true;
                _resetPage();
              }
            }
            return Column(
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
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
                            _ignoreStates = false;
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
                          }
                        : null,
                    child: state.states == DatabaseStates.productsBeingLoaded
                        ? CircularProgressIndicator()
                        : Text('Push the changes'),
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
