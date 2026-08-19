import 'package:flutter/material.dart';

class MaterialShimeringPlaceHolder extends StatefulWidget {
  final double width;
  final double height;
  final double cornerRadius;
  final Color color;
  final Color? shimeringColor;
  final int? cycleLongevityFactor;
  const MaterialShimeringPlaceHolder({
    super.key,
    required this.width,
    required this.height,
    required this.cornerRadius,
    required this.color,
    this.shimeringColor,
    this.cycleLongevityFactor,
  });

  @override
  State<MaterialShimeringPlaceHolder> createState() =>
      _MaterialShimeringPlaceHolderState();
}

class _MaterialShimeringPlaceHolderState
    extends State<MaterialShimeringPlaceHolder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400 - (widget.height / 2).toInt()),
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              widget.color,
              (widget.shimeringColor ?? Colors.white).withValues(alpha: .4),
              widget.color,
            ],
            stops: const [.3, .6, .7],
            begin: .topCenter,
            end: .bottomCenter,
            transform: _SlidingGradientTransform(
              slidePercent: _controller.value,
            ),
          ).createShader(bounds),
          child: child,
        );
      },
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

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      0,
      bounds.width * (slidePercent * 5 - 1.5),
      0,
    );
  }
}
