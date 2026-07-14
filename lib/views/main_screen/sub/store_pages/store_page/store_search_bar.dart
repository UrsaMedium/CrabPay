import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

class StoreSearchBarState extends StatefulWidget {
  final List<Product> products;
  final OnOpenProductCardCallBack _openProductCardCallBack;
  final Function(List<Product>) _onSearchSubmitedCallBack;
  const StoreSearchBarState({
    super.key,
    required this.products,
    required OnOpenProductCardCallBack openProductCardCallBack,
    required Function(List<Product>) onSearchSubmitedCallBack,
  }) : _onSearchSubmitedCallBack = onSearchSubmitedCallBack,
       _openProductCardCallBack = openProductCardCallBack;

  @override
  State<StoreSearchBarState> createState() => _StoreSearchBarStateState();
}

class _StoreSearchBarStateState extends State<StoreSearchBarState> {
  late KeyboardDetectionController _keyboardDetectionController;
  KeyboardState _keyboardState = KeyboardState.hidden;
  bool _keyBoardEventCanBeTriggered = false;
  bool _isSearchOpen = false;
  String? _userInput;
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    _keyboardDetectionController = KeyboardDetectionController(
      onChanged: (value) {
        _keyboardState = value;
      },
    );

    _keyboardDetectionController.registerCallback((state) {
      if (_keyBoardEventCanBeTriggered &&
          _keyboardState == KeyboardState.hiding) {
        _keyBoardEventCanBeTriggered = false;
        _userInput = null;
        _searchController.text = '';
        setState(() {
          _isSearchOpen = false;
        });
      }
      return true;
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isUserInputEmpty() {
    return _userInput == null || _userInput == '';
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDetection(
      controller: _keyboardDetectionController,
      child: Positioned(
        top: MediaQuery.paddingOf(context).top + 16,
        right: 32,
        child: ClipRRect(
          borderRadius: .circular(30),
          child: AnimatedSize(
            onEnd: () {
              if (_isSearchOpen && !_searchController.isOpen) {
                _searchController.openView();
              }
            },
            duration: const Duration(milliseconds: 400),
            curve: Curves.linearToEaseOut,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 150),
              layoutBuilder: (currentChild, previousChildren) => Stack(
                children: [
                  _isSearchOpen
                      ? _expandedSearchBar(context)
                      : _collapsedSearchBar(context),
                ],
              ),
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
        filter: .blur(sigmaX: 8, sigmaY: 8),
        child: GestureDetector(
          onTap: () {
            _keyBoardEventCanBeTriggered = true;
            setState(() {
              _isSearchOpen = true;
            });
          },
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
                  Text(
                    _isUserInputEmpty() ? 'Search' : '$_userInput',
                    style: TextStyle(fontWeight: .w500),
                  ),
                  IconButton(
                    onPressed: _isUserInputEmpty()
                        ? () {
                            _keyBoardEventCanBeTriggered = true;
                            setState(() {
                              _isSearchOpen = true;
                            });
                          }
                        : () {
                            setState(() {
                              _userInput = null;
                              _searchController.text = '';
                              widget._onSearchSubmitedCallBack([]);
                            });
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
        searchController: _searchController,
        suggestionsBuilder: (context, controller) {
          _userInput = controller.text.toLowerCase().trim();
          final suggestions = widget.products
              .where(
                (option) =>
                    option.name.toLowerCase().contains(_userInput ?? ''),
              )
              .map(
                (option) => ListTile(
                  title: Text(option.name),
                  onTap: () async {
                    final index = widget.products.indexOf(option);
                    _keyBoardEventCanBeTriggered = false;
                    controller.closeView(option.name);
                    widget._openProductCardCallBack(
                      context: context,
                      productId: option.id,
                      additionalSuffix: 'storeSearch',
                      index: index,
                    );
                  },
                ),
              );
          return suggestions.toList();
        },
        onSubmitted: (value) {
          _keyBoardEventCanBeTriggered = false;
          _searchController.text = '';
          _userInput = value.trim();
          _isSearchOpen = false;
          widget._onSearchSubmitedCallBack(
            widget.products
                .where(
                  (product) =>
                      product.name.toLowerCase().contains(value.toLowerCase()),
                )
                .toList(),
          );
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
