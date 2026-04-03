import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Home Row One'),
        Text('Home Row Two'),
        Text('Home Row Three'),
      ],
    );
  }
}
