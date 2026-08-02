import 'package:flutter/widgets.dart';

class AppUpwardReveresClipper extends CustomClipper<Path> {
  final double radius;
  final bool isUpward;

  AppUpwardReveresClipper({
    super.reclip,
    required this.radius,
    required this.isUpward,
  });

  @override
  Path getClip(Size size) {
    final Path path = Path();
    if (isUpward) {
      path.moveTo(0, size.height);
      path.arcToPoint(
        Offset(radius, size.height - radius),
        radius: Radius.circular(radius),
        clockwise: true,
      );
      path.lineTo(size.width - radius, size.height - radius);
      path.arcToPoint(
        Offset(size.width, size.height),
        radius: Radius.circular(radius),
        clockwise: true,
      );
      // path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.arcToPoint(
        Offset(radius, radius),
        radius: Radius.circular(radius),
        clockwise: false,
      );
      path.lineTo(size.width - radius, radius);
      path.arcToPoint(
        Offset(size.width, 0),
        radius: Radius.circular(radius),
        clockwise: false,
      );
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(covariant AppUpwardReveresClipper oldClipper) =>
      oldClipper.radius != radius;
}
