import 'package:crabpay/views/main_screen/sub/orders_view/driver/crab_order_model.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/cubit.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/order_card/material_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialSearchedOrdersPage extends StatelessWidget {
  final Function(String) onSupportSendMessagePressed;
  final Function(DateTime?, DateTime?, String?) onLoadMoreSearchedOrders;
  const MaterialSearchedOrdersPage({
    super.key,
    required this.onSupportSendMessagePressed,
    required this.onLoadMoreSearchedOrders,
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
                top: MediaQuery.paddingOf(context).top + 40,
              ),
              sliver: Builder(
                builder: (context) {
                  final crabOrders = context
                      .select<OrdersViewCubit, List<CrabOrder>>(
                        (cubit) => cubit.state.crabSearchedOrders ?? [],
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 100,
                    ),
                    child: SizedBox.shrink(
                      child: isLoadingMore
                          ? CircularProgressIndicator()
                          : Text('Your Searched Orders'),
                    ),
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
