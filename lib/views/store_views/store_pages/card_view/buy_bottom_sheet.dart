import 'package:flutter/material.dart';

class BuyBottomSheet extends StatelessWidget {
  const BuyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                alignment: AlignmentGeometry.bottomRight,
                child: Text('data'),
              ),
            ),
            SliverToBoxAdapter(child: TextField()),
            SliverToBoxAdapter(child: TextField()),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  RadioMenuButton(
                    value: 'value',
                    groupValue: 'groupValue',
                    onChanged: (_) {},
                    child: Text('data'),
                  ),
                  RadioMenuButton(
                    value: 'value',
                    groupValue: 'groupValue',
                    onChanged: (_) {},
                    child: Text('data'),
                  ),
                  RadioMenuButton(
                    value: 'value',
                    groupValue: 'groupValue',
                    onChanged: (_) {},
                    child: Text('data'),
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
