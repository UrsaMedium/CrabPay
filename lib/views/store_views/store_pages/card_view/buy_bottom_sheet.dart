import 'package:flutter/material.dart';

class BuyBottomSheet extends StatelessWidget {
  const BuyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('data'),
        TextField(),
        TextField(),
        RadioMenuButton(
          value: 'value',
          groupValue: 'groupValue',
          onChanged: (_) {},
          child: AboutDialog(),
        ),
        RadioGroup(onChanged: (_) {}, child: AboutDialog()),
      ],
    );
  }
}
