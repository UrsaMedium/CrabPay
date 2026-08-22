import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/_sub/store_category_view/material_store_category_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreCategoryViewDriver extends StatefulWidget {
  static const String routeName = 'category';
  final String tag;
  const StoreCategoryViewDriver({super.key, required this.tag});

  @override
  State<StoreCategoryViewDriver> createState() =>
      _StoreCategoryViewDriverState();
}

class _StoreCategoryViewDriverState extends State<StoreCategoryViewDriver> {
  late final List<Product> products;
  List<Product> filteredProducts = [];
  @override
  void initState() {
    products = (context.read<DatabaseBloc>().state.products ?? [])
        .where((element) => element.category == widget.tag)
        .toList();
    super.initState();
  }

  void _onSearchSubmitedCallBack(List<Product> productsFromSearch) {
    filteredProducts = productsFromSearch;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialStoreCategoryView(
      tag: widget.tag,
      products: filteredProducts.isEmpty ? products : filteredProducts,
      onSearchSubmitedCallBack: (prdcts) => _onSearchSubmitedCallBack(prdcts),
    );
  }
}
