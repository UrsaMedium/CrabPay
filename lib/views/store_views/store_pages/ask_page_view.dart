import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            context.go('/add_text_view');
          },
          child: Text('Text'),
        ),
        ElevatedButton(
          onPressed: () {
            context.go('/add_input_field_view');
          },
          child: Text('InputField'),
        ),
        ElevatedButton(
          onPressed: () {
            context.go('/add_radio_list_view');
          },
          child: Text('RadioList'),
        ),
        ElevatedButton(
          onPressed: () {
            context.go('/add_dropdown_list_view');
          },
          child: Text('DropdownList'),
        ),
        ElevatedButton(
          onPressed: () {
            context.go('/add_divider_view');
          },
          child: Text('Divider'),
        ),
      ],
    );
  }
}
