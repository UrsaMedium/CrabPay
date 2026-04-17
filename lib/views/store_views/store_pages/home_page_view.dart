import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/card_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageView extends StatefulWidget {
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
          SliverToBoxAdapter(child: Container(height: 8)),
          SliverToBoxAdapter(
            child: _appHomeCard(
              context,
              18 / 7,
              'lib/assets/images/gas-gas-gas.jpg',
              'GAS GAS GAS',
              'I\'m gonna step on the gas',
              'Tonight I\'ll fly',
              '1',
            ),
          ),
          SliverToBoxAdapter(
            child: _appHomeCard(
              context,
              18 / 7,
              'lib/assets/images/pubg.webp',
              'Pew Pew',
              'I fock in ass',
              'Buy me, daddy',
              'pew-pew-game',
            ),
          ),
          SliverToBoxAdapter(
            child: _appHomeCard(
              context,
              18 / 7,
              'lib/assets/images/steam-ru.webp',
              'Gaben, baby',
              'Make gaben happy',
              'Throw money',
              'gaben-game',
            ),
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
    String path,
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
                        return context.goNamed(
                          CardView.routeName,
                          pathParameters: {'id': path},
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
