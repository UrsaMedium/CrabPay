import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/store_page/_sub/store_page_search/material_store_search_bar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

class MaterialStoreSearchBarDriver extends StatefulWidget {
  final List<Product> products;
  final Function(List<Product>) onSearchSubmitedCallBack;
  const MaterialStoreSearchBarDriver({
    super.key,
    required this.products,
    required this.onSearchSubmitedCallBack,
  });

  @override
  State<MaterialStoreSearchBarDriver> createState() =>
      _MaterialStoreSearchBarDriverState();
}

class _MaterialStoreSearchBarDriverState
    extends State<MaterialStoreSearchBarDriver> {
  late KeyboardDetectionController _keyboardDetectionController;
  late final TextEditingController _universalController;
  KeyboardState _keyboardState = KeyboardState.hidden;
  bool _keyBoardEventCanBeTriggered = false;
  bool _isSearchOpen = false;

  @override
  void initState() {
    _universalController = TextEditingController();
    _keyboardDetectionController = KeyboardDetectionController(
      onChanged: (state) => _keyboardState = state,
    );

    _keyboardDetectionController.registerCallback((state) {
      if (_keyBoardEventCanBeTriggered &&
          _keyboardState == KeyboardState.hiding) {
        _keyBoardEventCanBeTriggered = false;
        _universalController.clear();
        setState(() {
          _isSearchOpen = false;
        });
        widget.onSearchSubmitedCallBack([]);
      }
      return true;
    });
    super.initState();
  }

  @override
  void dispose() {
    _universalController.dispose();
    super.dispose();
  }

  void _onOpenSearch() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'StoreSearchBarDriver _onOpenSearch',
    );
    _keyBoardEventCanBeTriggered = true;
    setState(() {
      _isSearchOpen = true;
    });
  }

  void _onClear() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'StoreSearchBarDriver _onClear',
    );
    setState(() {
      _universalController.clear();
      widget.onSearchSubmitedCallBack([]);
    });
  }

  void _onSubmitted(String query) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'StoreSearchBarDriver _onSubmitted',
      data: {'query': query},
    );
    _keyBoardEventCanBeTriggered = false;
    setState(() {
      _isSearchOpen = false;
    });
    final filtered = widget.products
        .where(
          (product) =>
              product.name.toLowerCase().contains(query.toLowerCase().trim()),
        )
        .toList();
    widget.onSearchSubmitedCallBack(filtered);
  }

  void _onProductSelected(BuildContext context, Product product, String tag) {
    _keyBoardEventCanBeTriggered = false;
    _universalController.clear();
    setState(() {
      _isSearchOpen = false;
    });
    globalOpenProductCardCallBack(
      context: context,
      productId: product.id,
      tag: tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      //  Return CupertinoStoreSearchBarView(...)
    }

    return KeyboardDetection(
      controller: _keyboardDetectionController,
      child: MaterialStoreSearchBarView(
        controller: _universalController,
        products: widget.products,
        isSearchOpen: _isSearchOpen,
        onOpenSearch: _onOpenSearch,
        onClear: _onClear,
        onSubmitted: _onSubmitted,
        onProductSelected: (product, tag) =>
            _onProductSelected(context, product, tag),
      ),
    );
  }
}
