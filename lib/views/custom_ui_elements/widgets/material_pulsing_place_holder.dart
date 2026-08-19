import 'package:flutter/material.dart';

class MaterialPulsingPlaceHolder extends StatefulWidget {
  final double width;
  final double height;
  final double cornerRadius;
  final Color color;
  final int? cycleLongevity;
  const MaterialPulsingPlaceHolder({
    super.key,
    required this.width,
    required this.height,
    required this.cornerRadius,
    required this.color,
    this.cycleLongevity,
  });

  @override
  State<MaterialPulsingPlaceHolder> createState() =>
      _MaterialPulsingPlaceHolderState();
}

class _MaterialPulsingPlaceHolderState extends State<MaterialPulsingPlaceHolder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityImage;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.cycleLongevity ?? 900),
    )..repeat(reverse: true);

    _opacityImage = Tween<double>(
      begin: 1,
      end: .6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInBack));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityImage,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: .circular(widget.cornerRadius),
          color: widget.color,
        ),
      ),
    );
  }
}
