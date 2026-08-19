import 'package:flutter/widgets.dart';

class MaterialStaticPlaceHolder extends StatelessWidget {
  final double width;
  final double height;
  final double cornerRadius;
  final Color color;
  const MaterialStaticPlaceHolder({
    super.key,
    required this.width,
    required this.height,
    required this.cornerRadius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: .circular(cornerRadius),
        color: color,
      ),
    );
  }
}
