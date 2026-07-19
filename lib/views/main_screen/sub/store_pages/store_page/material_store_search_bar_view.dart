import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class MaterialStoreSearchBarView extends StatefulWidget {
  final TextEditingController controller;
  final List<Product> products;
  final bool isSearchOpen;
  final VoidCallback onOpenSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onSubmitted;
  final Function(BuildContext, Product, int) onProductSelected;

  const MaterialStoreSearchBarView({
    super.key,
    required this.controller,
    required this.products,
    required this.isSearchOpen,
    required this.onOpenSearch,
    required this.onClear,
    required this.onSubmitted,
    required this.onProductSelected,
  });

  @override
  State<MaterialStoreSearchBarView> createState() =>
      _MaterialStoreSearchBarViewState();
}

class _MaterialStoreSearchBarViewState
    extends State<MaterialStoreSearchBarView> {
  late final SearchController _materialSearchController;

  @override
  void initState() {
    super.initState();
    _materialSearchController = SearchController()
      ..text = widget.controller.text
      ..addListener(_syncControllers);
  }

  void _syncControllers() {
    if (widget.controller.text != _materialSearchController.text) {
      widget.controller.text = _materialSearchController.text;
    }
  }

  @override
  void didUpdateWidget(covariant MaterialStoreSearchBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.text != _materialSearchController.text) {
      _materialSearchController.text = widget.controller.text;
    }
  }

  @override
  void dispose() {
    _materialSearchController.removeListener(_syncControllers);
    _materialSearchController.dispose();
    super.dispose();
  }

  bool _isUserInputEmpty() {
    return widget.controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 56,
      right: 32,
      child: ClipRRect(
        borderRadius: .circular(30),
        child: AnimatedSize(
          onEnd: () {
            if (widget.isSearchOpen && !_materialSearchController.isOpen) {
              _materialSearchController.openView();
            }
          },
          duration: const Duration(milliseconds: 400),
          curve: Curves.linearToEaseOut,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 150),
            layoutBuilder: (currentChild, previousChildren) => Stack(
              children: [
                widget.isSearchOpen
                    ? _expandedSearchBar(context)
                    : _collapsedSearchBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _collapsedSearchBar(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(30),
      child: BackdropFilter(
        filter: .blur(sigmaX: 12, sigmaY: 12),
        child: GestureDetector(
          onTap: widget.onOpenSearch,
          child: Container(
            decoration: BoxDecoration(
              color: context.appColorScheme.surfaceContainerHigh.withValues(
                alpha: .6,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Text(
                      _isUserInputEmpty() ? 'Search' : widget.controller.text,
                      style: const TextStyle(fontWeight: .w500),
                    ),
                  ),
                  IconButton(
                    onPressed: _isUserInputEmpty()
                        ? widget.onOpenSearch
                        : () {
                            _materialSearchController.clear();
                            widget.onClear();
                          },
                    icon: Icon(
                      _isUserInputEmpty()
                          ? Icons.search_rounded
                          : Icons.clear_rounded,
                    ),
                    iconSize: 30,
                    constraints: const BoxConstraints(minWidth: 70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _expandedSearchBar(BuildContext context) {
    double transparenvyLevel = .96;
    return Container(
      width: MediaQuery.sizeOf(context).width - 64,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: SearchAnchor.bar(
        searchController: _materialSearchController,
        suggestionsBuilder: (context, controller) {
          final query = controller.text.toLowerCase().trim();
          final suggestions = widget.products
              .where((option) => option.name.toLowerCase().contains(query))
              .map(
                (option) => ListTile(
                  title: Text(option.name),
                  onTap: () {
                    final index = widget.products.indexOf(option);
                    controller.closeView(option.name);
                    widget.onProductSelected(context, option, index);
                  },
                ),
              );
          return suggestions.toList();
        },
        onSubmitted: (value) {
          _materialSearchController.closeView(value);
          widget.onSubmitted(value);
        },
        isFullScreen: false,
        shrinkWrap: true,
        dividerColor: Colors.transparent,
        barBackgroundColor: WidgetStateProperty.all(
          context.appColorScheme.surfaceContainerHigh.withValues(
            alpha: transparenvyLevel,
          ),
        ),
        viewBackgroundColor: context.appColorScheme.surfaceContainerHigh
            .withValues(alpha: transparenvyLevel),
        viewConstraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width - 64,
          maxHeight: 314,
        ),
      ),
    );
  }
}
