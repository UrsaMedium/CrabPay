import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_controller.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageView extends StatefulWidget {
  // final String id;
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  List<Product> appProducts = DatabaseDataHandler().products();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return _appHomeCard(context, 18 / 7, appProducts[index]);
            }, childCount: appProducts.length),
            itemExtent: 242,
          ),
        ],
      ),
    );
  }

  Widget _appHomeCard(
    BuildContext context,
    double ratio,
    Product currentProduct,
  ) {
    return Hero(
      tag: 'card-hero-${currentProduct.id}',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Card(
          clipBehavior: .antiAlias,
          shape: RoundedRectangleBorder(borderRadius: .circular(32)),
          color: context.appColorScheme.surfaceContainer,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              AspectRatio(
                aspectRatio: ratio,
                child: Image.asset(currentProduct.image, fit: .cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              currentProduct.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: context.appColorScheme.primary,
                              ),
                            ),
                            Text(currentProduct.description),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed(
                            'card-view',
                            pathParameters: {'productId': currentProduct.id},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.appColorScheme.primary,
                          foregroundColor: context.appColorScheme.onPrimary,
                        ),
                        child: Text('ook'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
