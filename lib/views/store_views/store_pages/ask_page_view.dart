import 'package:crabpay/core/admin/powers_views_utilities.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/inner_pap_handler.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_outer_circle/outer_pap_handler.dart';
import 'package:flutter/material.dart';

class AskPageView extends StatelessWidget {
  const AskPageView({super.key});

  @override
  Widget build(BuildContext context) {
    InnerProductAndPropertiesHandler handler =
        OuterProductAndPropertiesHandler();
    return Column(
      children: [
        const Text('Ask Row One'),
        const Text('Ask Row Two'),
        ElevatedButton(
          onPressed: () async {
            await handler.fetchAllPAPData();
          },
          child: Text('fetcher'),
        ),
        Column(children: adminPowersButtons(context)),
      ],
    );
  }
}
