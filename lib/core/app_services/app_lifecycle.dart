import 'dart:async';

import 'package:flutter/widgets.dart';

enum AppState { active, paused }

class AppLifecycleService {
  final _stateControler = StreamController<AppState>.broadcast();
  late final AppLifecycleListener _listener;

  Stream<AppState> get appStateStream => _stateControler.stream;

  AppLifecycleService() {
    _listener = AppLifecycleListener(
      onStateChange: (state) {
        if (state == AppLifecycleState.resumed) {
          _stateControler.add(AppState.active);
        } else if (state == AppLifecycleState.paused) {
          _stateControler.add(AppState.paused);
        }
      },
    );
  }

  void dispose() {
    _listener.dispose();
    _stateControler.close();
  }
}
