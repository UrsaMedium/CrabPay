import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductFieldUpdateView extends StatefulWidget {
  const ProductFieldUpdateView({super.key});

  @override
  State<ProductFieldUpdateView> createState() => _ProductFieldUpdateViewState();
}

class _ProductFieldUpdateViewState extends State<ProductFieldUpdateView> {
  List<Product>? _products;
  List<DropdownMenuEntry<Product>>? _productDropDownMenuEntries;
  final TextEditingController _productDropDownMenuController =
      TextEditingController();
  Product? _selectedProduct;
  ProductField? _selectedField;

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
            const ProductFieldUpdateView(),
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

  void _onBottomSheetDataRetrieved(String a, String b) {}

  List<Widget> _fieldSlivers(List<ProductField> fields) {
    fields.sort((a, b) => a.order.compareTo(b.order));
    List<Widget> result = [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32.0,
            top: 16,
            bottom: 8,
            right: 128,
          ),
          child: SizedBox(
            child: Text(
              _selectedProduct?.name ?? 'error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: .w700,
                color: context.appColorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    ];
    for (var field in fields) {
      result.add(
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedField = field;
              });
            },
            child: AbsorbPointer(
              absorbing: true,
              child: theAppWidgetBuilder(
                collectedDataBridge: _onBottomSheetDataRetrieved,
                context: context,
                fieldName: field.fieldName,
                handler: field.handler,
                priceImages: field.priceImages,
                expectedData: field.expectedData,
              ),
            ),
          ),
        ),
      );
    }
    result.add(SliverToBoxAdapter(child: SizedBox(height: 66)));
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
        body: Center(
          child: Column(
            crossAxisAlignment: .center,
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
                    if (_selectedProduct != null) {
                      context.read<DatabaseBloc>().add(
                        DatabaseEventFetchProductFields(
                          productId: _selectedProduct!.id,
                        ),
                      );
                    }
                    _selectedField = null;
                  }),
                  menuHeight: 432,
                ),
              ),
              _selectedField == null
                  ? _selectedProduct != null
                        ? Flexible(
                            child: CustomScrollView(
                              slivers: _fieldSlivers(
                                context
                                        .read<DatabaseBloc>()
                                        .state
                                        .productFields ??
                                    [],
                              ),
                            ),
                          )
                        : Text('Choose a product first')
                  : Text(_selectedField!.fieldName),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _selectedProduct != null
                      ? () {
                          reloadView(context);
                        }
                      : null,
                  child: Text('Push the changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
