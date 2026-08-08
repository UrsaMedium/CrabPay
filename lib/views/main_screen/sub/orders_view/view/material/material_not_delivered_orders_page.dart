import 'package:crabpay/views/main_screen/sub/orders_view/driver/crab_order_model.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/cubit.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/material_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialNotDeliveredOrdersPage extends StatefulWidget {
  final VoidCallback onLoadMoreNotDeliveredOrders;
  final Function(String) onSupportSendMessagePressed;
  const MaterialNotDeliveredOrdersPage({
    super.key,
    required this.onLoadMoreNotDeliveredOrders,
    required this.onSupportSendMessagePressed,
  });

  @override
  State<MaterialNotDeliveredOrdersPage> createState() =>
      _MaterialNotDeliveredOrdersPageState();
}

class _MaterialNotDeliveredOrdersPageState
    extends State<MaterialNotDeliveredOrdersPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                        (cubit) => cubit.state.crabNotDeliveredOrders ?? [],
                      );

                  return SliverList.builder(
                    itemCount: crabOrders.length,
                    itemBuilder: (context, index) {
                      return MaterialOrderCard(
                        crabOrder: crabOrders[index],
                        onSupportSendMessagePressed:
                            widget.onSupportSendMessagePressed,
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
                    (cubit) => cubit.state.hasMoreNotDeliveredOrders,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 100,
                    ),
                    child: ElevatedButton(
                      onPressed: hasMore
                          ? widget.onLoadMoreNotDeliveredOrders
                          : null,
                      child: isLoadingMore
                          ? CircularProgressIndicator()
                          : Text(hasMore ? 'Load More' : 'That\'s it'),
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
