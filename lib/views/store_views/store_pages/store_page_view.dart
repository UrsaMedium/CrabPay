import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class StorePageView extends StatelessWidget {
  const StorePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Store Row One'),
        Text('Store Row Two'),
        Text('Store Row Three'),
        // TextButton(onPressed: (){context.go('/view')}), child: child)
      ],
    );
  }
}
