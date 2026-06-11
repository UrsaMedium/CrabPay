import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class CartPageView extends StatelessWidget {
  const CartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Shopping Cart',
                textAlign: .left,
                style: TextStyle(
                  color: context.appColorScheme.primaryFixedDim,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text('Confirm the purchase', textAlign: .left),
            ),
            CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverList.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    //TODO
                    return Card(
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      color: context.appColorScheme.surfaceContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: context.appColorScheme.surfaceContainerHigh,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Image.asset(
                                'lib/assets/images/gas-gas-gas.jpg',
                                fit: .cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text('Name of the product $index'),
                                    Text(
                                      '00.00',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: context.appColorScheme.primary,
                                        fontWeight: .w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: context.appColorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: IconButton(iconSize: 25,padding: .all(0),
                                onPressed: () {},
                                icon: Icon(Icons.delete_outline_rounded),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Divider(thickness: 2),
            ),
            Card(
              elevation: 3,
              clipBehavior: Clip.antiAlias,
              color: context.appColorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),

                side: BorderSide(
                  color: context.appColorScheme.surfaceContainerHigh,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    //TODO
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8,
                      ),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,

                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total',
                              style: TextStyle(fontSize: 16, fontWeight: .w500),
                            ),
                          ),
                          Text('00.0'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.appColorScheme.primary,
                        foregroundColor: context.appColorScheme.onPrimary,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
