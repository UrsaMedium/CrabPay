import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/product_card.dart';
import 'package:flutter/material.dart';

class MaterialStoreCategoryView extends StatelessWidget {
  final String tag;
  final List<Product> products;
  const MaterialStoreCategoryView({
    super.key,
    required this.tag,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: .only(
              top: MediaQuery.paddingOf(context).top + 8,
              bottom: MediaQuery.paddingOf(context).bottom + 16,
              right: 8,
              left: 8,
            ),
            sliver: Builder(
              builder: (context) {
                return SliverCrossAxisGroup(
                  slivers: [
                    SliverPadding(
                      padding: .only(right: 4),
                      sliver: SliverList.builder(
                        itemCount: (products.length + 1) ~/ 2,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ProductCardDriver(
                            product: products[index * 2],
                            tag: '${products[index * 2].id}-$tag',
                            height: 256,
                            width: (MediaQuery.widthOf(context) - 24) / 2,
                            cornerRadius: 16,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: .only(left: 4),
                      sliver: SliverList.builder(
                        itemCount: products.length ~/ 2,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(top: index == 0 ? 60 : 8),
                          child: ProductCardDriver(
                            product: products[index * 2 + 1],
                            tag: '${products[index * 2 + 1].id}-$tag',
                            height: 256,
                            width: (MediaQuery.widthOf(context) - 24) / 2,
                            cornerRadius: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
