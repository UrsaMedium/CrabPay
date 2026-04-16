import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('lib/assets/images/gas-gas-gas.jpg'),
        Text('data'),
      ],
    );
  }
}
