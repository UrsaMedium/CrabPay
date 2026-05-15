import 'package:crabpay/core/admin/powers_views_utilities.dart';
import 'package:flutter/material.dart';

class AskPageView extends StatelessWidget {
  const AskPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Ask Row One'),
        const Text('Ask Row Two'),
        Column(children: adminPowersButtons(context)),
      ],
    );
  }
}
