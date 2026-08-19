import 'package:flutter/material.dart';

class HeroFlightObserver extends StatefulWidget {
  final Widget child;
  final VoidCallback onFlightStarted;
  final VoidCallback onFlightEnded;
  const HeroFlightObserver({
    super.key,
    required this.child,
    required this.onFlightEnded,
    required this.onFlightStarted,
  });

  @override
  State<HeroFlightObserver> createState() => _HeroFlightObserverState();
}

class _HeroFlightObserverState extends State<HeroFlightObserver> {
  @override
  void initState() {
    widget.onFlightStarted();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onFlightEnded());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

//falback

class HeroFlightObserverWithFallBack extends StatefulWidget {
  final VoidCallback onHeroLanded;
  final Widget Function(
    BuildContext context,
    VoidCallback onFlightStarted,
    VoidCallback onHeroFlightEnd,
  )
  builder;
  const HeroFlightObserverWithFallBack({
    super.key,
    required this.onHeroLanded,
    required this.builder,
  });

  @override
  State<HeroFlightObserverWithFallBack> createState() =>
      _HeroFlightObserverWithFallBackState();
}

class _HeroFlightObserverWithFallBackState
    extends State<HeroFlightObserverWithFallBack> {
  bool _flightStarted = false;
  bool _hasExecuted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (route?.animation != null) {
        if (route!.animation!.isCompleted) {
          _checkFallBackMethod();
        } else {
          void handler(AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              route.animation!.removeStatusListener(handler);
              _checkFallBackMethod();
            }
          }

          route.animation!.addStatusListener(handler);
        }
      } else {
        _checkFallBackMethod();
      }
    });
  }

  void _checkFallBackMethod() {
    if (!_flightStarted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _triggerCallback();
        });
      });
    }
  }

  void _onFlightStarted() {
    _flightStarted = true;
  }

  void _onFlightEnded() {
    _triggerCallback();
  }

  void _triggerCallback() {
    if (_hasExecuted) return;
    _hasExecuted = true;
    if (mounted) {
      widget.onHeroLanded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _onFlightStarted, _onFlightEnded);
  }
}
