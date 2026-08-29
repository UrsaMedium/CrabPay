import 'package:crabpay/views/main_screen/_sub/store_pages/home_page/view/material/material_home_page_favorite_container.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/home_page/view/material/material_home_page_featured_container.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class MaterialHomePageView extends StatelessWidget {
  final Future<void> Function() reFresher;
  const MaterialHomePageView({super.key, required this.reFresher});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: MediaQuery.paddingOf(context).top,
      onRefresh: reFresher,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              left: 16,
              right: 16,
              top: MediaQuery.paddingOf(context).top + 16,
              bottom: MediaQuery.paddingOf(context).bottom + 16,
            ),
            child: Column(
              children: [
                MaterialHomePageFeaturedContainer(),
                Padding(
                  padding: .symmetric(horizontal: 22, vertical: 6),
                  child: Divider(),
                ),
                MaterialHomePageFavoriteContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
