import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class StoreSearchBarState extends StatefulWidget {
  final Function(bool) _isSearchedFocusedCallBack;
  const StoreSearchBarState({
    super.key,
    required Function(bool) isSearchedFocusedCallBack,
  }) : _isSearchedFocusedCallBack = isSearchedFocusedCallBack;

  @override
  State<StoreSearchBarState> createState() => _StoreSearchBarStateState();
}

class _StoreSearchBarStateState extends State<StoreSearchBarState> {
  bool _isSearchedFocused = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 16,
      right: 32,
      child: ClipRRect(
        borderRadius: .circular(30),
        child: TapRegion(
          onTapInside: (event) => setState(() {
            _isSearchedFocused = true;
            widget._isSearchedFocusedCallBack(_isSearchedFocused);
          }),
          onTapOutside: (event) => setState(() {
            _isSearchedFocused = false;
            widget._isSearchedFocusedCallBack(_isSearchedFocused);
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastLinearToSlowEaseIn,
            height: _isSearchedFocused ? 60 : 50,
            width: _isSearchedFocused
                ? MediaQuery.sizeOf(context).width - 64
                : 115,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: _isSearchedFocused
                  ? _expandedSearchBar(context)
                  : _collapsedSearchBar(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _collapsedSearchBar(BuildContext context) {
    return BackdropFilter(
      filter: .blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        decoration: BoxDecoration(
          color: context.appColorScheme.surfaceContainerHigh.withValues(
            alpha: .6,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Text('Search  ', style: TextStyle(fontWeight: .w500)),
              Icon(Icons.search_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _expandedSearchBar(BuildContext context) {
    return BackdropFilter(
      filter: .blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        decoration: BoxDecoration(
          color: context.appColorScheme.surfaceContainerHigh.withValues(
            alpha: .6,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: SearchAnchor.bar(
          suggestionsBuilder: (context, controller) => [],
          isFullScreen: false,
          shrinkWrap: true,
          barBackgroundColor: WidgetStateProperty.all(
            context.appColorScheme.surfaceContainerHigh.withValues(alpha: .6),
          ),
          viewConstraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width - 64,
            minHeight: 120,
          ),
          viewBackgroundColor: context.appColorScheme.surfaceContainerHigh
              .withValues(alpha: .95),
          viewBuilder: (suggestions) {
            return ClipRRect(
              borderRadius: .circular(30),
              child: BackdropFilter(
                filter: .blur(sigmaX: 2, sigmaY: 2),
                child: ListView(children: suggestions.toList()),
              ),
            );
          },
        ),
      ),
    );
  }
}
