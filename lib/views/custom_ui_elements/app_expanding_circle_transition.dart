import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppExpandingCircleTransitionClipper extends CustomClipper<Path> {
  final Offset center;
  final double transitionFraction;

  AppExpandingCircleTransitionClipper({
    super.reclip,
    required this.center,
    required this.transitionFraction,
  });

  double _distance(Offset x, Offset y) {
    return sqrt(pow(x.dx - y.dx, 2) + pow(x.dy - y.dy, 2));
  }

  @override
  Path getClip(Size size) {
    final double distanceToTopLeft = _distance(center, const Offset(0, 0));
    final double distanceToTopRight = _distance(center, Offset(size.width, 0));
    final double distanceToBottomLeft = _distance(
      center,
      Offset(0, size.height),
    );
    final double distanceToBottomRight = _distance(
      center,
      Offset(size.width, size.height),
    );

    final double maxRadius = max(
      max(distanceToTopLeft, distanceToTopRight),
      max(distanceToBottomLeft, distanceToBottomRight),
    );

    final double currentRadius = maxRadius * transitionFraction;

    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: currentRadius));
  }

  @override
  bool shouldReclip(covariant AppExpandingCircleTransitionClipper oldClipper) =>
      oldClipper.transitionFraction != transitionFraction ||
      oldClipper.center != center;
}

class AppExpandingCircleTransitionRoute {
  static Page<dynamic> circularReveal({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return MaterialPage<void>(key: state.pageKey, child: child);
    }

    final Offset tapPosition =
        state.extra as Offset? ??
        Offset(
          MediaQuery.sizeOf(context).width / 2,
          MediaQuery.sizeOf(context).height / 2,
        );
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );
        return AnimatedBuilder(
          animation: curvedAnimation,
          builder: (context, child) {
            return ClipPath(
              clipper: AppExpandingCircleTransitionClipper(
                center: tapPosition,
                transitionFraction: curvedAnimation.value,
              ),
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}
