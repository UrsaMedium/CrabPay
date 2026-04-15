import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                clipBehavior: .antiAlias,
                shape: RoundedRectangleBorder(borderRadius: .circular(32)),
                color: context.appColorScheme.surfaceContainerHighest,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Image.asset(
                      'lib/assets/images/gas-gas-gas.jpg',
                      fit: .cover,
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
                                    'GAS GAS GAS',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: context.appColorScheme.primary,
                                    ),
                                  ),
                                  const Text('I\'m gonna step on the gas'),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.appColorScheme.primary,
                                foregroundColor:
                                    context.appColorScheme.onPrimary,
                              ),
                              child: Text('Tonight I\'ll fly'),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                clipBehavior: .antiAlias,
                shape: RoundedRectangleBorder(borderRadius: .circular(32)),
                color: context.appColorScheme.surfaceContainerHighest,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Image.asset('lib/assets/images/pubg.webp', fit: .cover),
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
                                    'Pew Pew',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: context.appColorScheme.primary,
                                    ),
                                  ),
                                  const Text('I fock in ass'),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.appColorScheme.primary,
                                foregroundColor:
                                    context.appColorScheme.onPrimary,
                              ),
                              child: Text('Buy me, daddy'),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                clipBehavior: .antiAlias,
                shape: RoundedRectangleBorder(borderRadius: .circular(32)),
                color: context.appColorScheme.surfaceContainerHighest,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Image.asset(
                      'lib/assets/images/steam-ru.webp',
                      fit: .cover,
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
                                    'Gaben, baby',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: context.appColorScheme.primary,
                                    ),
                                  ),
                                  const Text('Make gaben happy'),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.appColorScheme.primary,
                                foregroundColor:
                                    context.appColorScheme.onPrimary,
                              ),
                              child: Text('Throw money'),
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
        ],
      ),
    );
  }
}
