import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    if (context.read<DatabaseBloc>().state.products == null ||
        context.read<DatabaseBloc>().state.products == []) {
      context.read<DatabaseBloc>().add(DatabaseEventFetchAllProducts());
      context.read<DatabaseBloc>().add(DatabaseEventFetchAllCurrencies());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DatabaseBloc>().add(DatabaseEventFetchAllCurrencies());
          context.read<DatabaseBloc>().add(DatabaseEventFetchAllProducts());
          await context.read<DatabaseBloc>().stream.firstWhere(
            (state) =>
                (state.states == DatabaseStates.productsFetched ||
                state.states == DatabaseStates.productsNotFetched),
          );
        },
        child: CustomScrollView(
          slivers: [
            BlocBuilder<DatabaseBloc, DatabaseState>(
              buildWhen: (previous, current) =>
                  current.states == DatabaseStates.productsFetched,
              builder: (context, state) {
                final products =
                    context.read<DatabaseBloc>().state.products ?? [];
                final productCards = _appHomeCard(context, products);
                return SliverList.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) => productCards[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _appHomeCard(BuildContext context, List<Product> products) {
    List<Widget> result = [];
    for (var product in products) {
      result.add(
        Hero(
          tag: 'card-hero-${product.id}',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Card(
              clipBehavior: .antiAlias,
              shape: RoundedRectangleBorder(borderRadius: .circular(32)),
              color: context.appColorScheme.surfaceContainer,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Image.network(
                    'http://regred-rainbowbridge.ru/crabpay/images/products/${product.image}',
                    width: double.infinity,
                    height: 200,
                    fit: .cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: context.appColorScheme.onInverseSurface,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image,
                        color: context.appColorScheme.inversePrimary,
                        size: 48,
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: context.appColorScheme.inversePrimary,
                        alignment: .center,
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
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
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: context.appColorScheme.primary,
                                  ),
                                ),
                                Text(product.description),
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
                                pathParameters: {'productId': product.id},
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
        ),
      );
    }
    return result;
  }
}
