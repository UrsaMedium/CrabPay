import 'package:crabpay/core/product_data/product_data.dart';
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
              // return Text(index.toString());
              return _appHomeCard(
                context,
                18 / 7,
                appProducts[index].image,
                appProducts[index].name,
                appProducts[index].description,
                appProducts[index].name,
                appProducts[index].id,
              );
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
    String picture,
    String h1Line,
    String h2Line,
    String buttonText,
    String id,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Card(
        clipBehavior: .antiAlias,
        shape: RoundedRectangleBorder(borderRadius: .circular(32)),
        color: context.appColorScheme.surfaceContainerHighest,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            AspectRatio(
              aspectRatio: ratio,
              child: Image.asset(picture, fit: .cover),
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
                            h1Line,
                            style: TextStyle(
                              fontSize: 16,
                              color: context.appColorScheme.primary,
                            ),
                          ),
                          Text(h2Line),
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
                          pathParameters: {'productId': id},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.appColorScheme.primary,
                        foregroundColor: context.appColorScheme.onPrimary,
                      ),
                      child: Text(buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
