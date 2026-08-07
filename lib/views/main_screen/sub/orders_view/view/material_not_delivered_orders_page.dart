import 'package:crabpay/views/main_screen/sub/orders_view/driver/crab_order_model.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/cubit.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material_orders_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialNotDeliveredOrdersPage extends StatelessWidget {
  final VoidCallback onLoadMore;
  final Function(String) onSupportSendMessagePressed;
  const MaterialNotDeliveredOrdersPage({
    super.key,
    required this.onLoadMore,
    required this.onSupportSendMessagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 44,
              ),
              sliver: Builder(
                builder: (context) {
                  final crabOrders = context
                      .select<OrdersViewCubit, List<CrabOrder>>(
                        (cubit) => cubit.state.crabOrders ?? [],
                      );

                  return SliverList.builder(
                    itemCount: crabOrders.length,
                    itemBuilder: (context, index) {
                      return MaterialOrderCard(
                        crabOrder: crabOrders[index],
                        onSupportSendMessagePressed:
                            onSupportSendMessagePressed,
                      );
                    },
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Builder(
                builder: (context) {
                  final isLoadingMore = context.select<OrdersViewCubit, bool>(
                    (cubit) => cubit.state.isLoadingMore,
                  );
                  final hasMore = context.select<OrdersViewCubit, bool>(
                    (cubit) => cubit.state.hasMore,
                  );
                  return ElevatedButton(
                    onPressed: hasMore ? onLoadMore : null,
                    child: isLoadingMore
                        ? CircularProgressIndicator()
                        : Text(hasMore ? 'Load More' : 'That\'s it'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
