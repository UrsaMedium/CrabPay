import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialStoreSearchBarView extends StatefulWidget {
  final TextEditingController controller;
  final List<Product> products;
  final bool isSearchOpen;
  final VoidCallback onOpenSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onSubmitted;
  final Function(Product, String) onProductSelected;

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
    final highGraphics = context.select<GlobalGraphicBloc, bool>(
      (bloc) => bloc.state.highGraphics,
    );
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 12,
      right: 0,
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
                  : _collapsedSearchBar(context, highGraphics),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey _collapsedSearchBarKey = GlobalKey();
  Size? _collapsedSearchBarSize;
  Size? _oldCollapsedSearchBarSize;
  void _extractPositions() {
    final collapsedSearchBarContext = _collapsedSearchBarKey.currentContext;

    if (collapsedSearchBarContext != null) {
      final collapsedSearchBarRenderBox =
          collapsedSearchBarContext.findRenderObject() as RenderBox;

      final size = collapsedSearchBarRenderBox.size;
      if (size != _oldCollapsedSearchBarSize) {
        setState(() {
          _oldCollapsedSearchBarSize = _collapsedSearchBarSize;
          _collapsedSearchBarSize = size;
        });
      }
    }
  }

  Widget _collapsedSearchBar(BuildContext context, bool highGraphics) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extractPositions();
    });
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: widget.onOpenSearch,
        child: Stack(
          children: [
            Material(
              borderRadius: .circular(30),
              clipBehavior: .antiAlias,
              color: Colors.transparent,
              child: BackdropFilter(
                enabled: highGraphics,
                filter: .blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  key: _collapsedSearchBarKey,
                  color: context.appColorScheme.surfaceContainerHigh.withValues(
                    alpha: highGraphics ? .5 : .97,
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Container(
                          margin: .only(left: 16),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.widthOf(context) / 2 - 12 - 98,
                          ),
                          child: Text(
                            maxLines: 1,
                            _isUserInputEmpty()
                                ? 'Search'
                                : widget.controller.text,
                            overflow: .ellipsis,
                            style: const TextStyle(fontWeight: .w500),
                          ),
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
                        constraints: const BoxConstraints(minWidth: 32),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_collapsedSearchBarSize != null)
              IgnorePointer(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: .topCenter,
                    end: .bottomCenter,
                    colors: [
                      context.appColorScheme.outline.withValues(alpha: .2),
                      context.appColorScheme.outline.withValues(alpha: .1),
                      Colors.transparent,
                      Colors.transparent,
                      context.appColorScheme.outline.withValues(alpha: .1),
                    ],
                  ).createShader(bounds),
                  child: Container(
                    width: _collapsedSearchBarSize!.width,
                    height: _collapsedSearchBarSize!.height,
                    decoration: BoxDecoration(
                      borderRadius: .circular(30),
                      border: .all(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _expandedSearchBar(BuildContext context) {
    double transparenvyLevel = .96;
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Container(
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
                      widget.onProductSelected(
                        option,
                        '${option.id}-store-search-$index',
                      );
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
      ),
    );
  }
}
