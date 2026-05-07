import 'package:crabpay/core/product_data/product_properties/properties_data_outer_circle.dart';
import 'package:flutter/material.dart';

class AskPageView extends StatelessWidget {
  const AskPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Ask Row One'),
        const Text('Ask Row Two'),
        ElevatedButton(
          onPressed: () {
            passDataToBackEnd();
          },
          child: const Text('data'),
        ),
      ],
    );
  }
}

void passDataToBackEnd() {
  addProductWithProperties();
}
