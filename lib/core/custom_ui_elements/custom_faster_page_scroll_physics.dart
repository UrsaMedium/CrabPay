import 'package:flutter/widgets.dart';

class CustomFasterPageScrollPhysics extends PageScrollPhysics {
  const CustomFasterPageScrollPhysics({super.parent});

  @override
  CustomFasterPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomFasterPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 1, stiffness: 500, damping: 40);

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset * 3);
  }

  @override
  Tolerance get tolerance => const Tolerance(velocity: 10.0, distance: 1e-3);
}
