import 'package:crabpay/core/dialogs/on_login_dialog.dart';
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
              child: TextButton(onPressed: () async  {await showOnLoginDialog(context); return;}, child: Text('data')),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(onPressed: () {}, child: Text('data')),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(onPressed: () {}, child: Text('data')),
            ),
          ),
        ],
      ),
    );
  }
}
