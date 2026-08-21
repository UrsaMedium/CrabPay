import 'dart:async';

import 'package:crabpay/core/backend/connection_monitoring/inner_monitor/inner_connection_monitor.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectionState extends Equatable {
  final ServerConnectionStatus status;
  final String? error;

  const ConnectionState({
    this.status = ServerConnectionStatus.initial,
    this.error,
  });

  bool get isOnline => status == ServerConnectionStatus.online;

  @override
  List<Object?> get props => [status, error];
}

class ConnectionMonitorCubit extends Cubit<ConnectionState> {
  final InnerConnectionMonitor _connectionMonitor;
  late final StreamSubscription<ServerConnectionStatus> _statusSub;

  ConnectionMonitorCubit({required InnerConnectionMonitor connectionMonitor})
    : _connectionMonitor = connectionMonitor,
      super(ConnectionState(status: connectionMonitor.currentStatus)) {
    _statusSub = _connectionMonitor.statusStream.listen(
      (status) => emit(ConnectionState(status: status)),
    );
  }

  @override
  Future<void> close() {
    _statusSub.cancel();
    return super.close();
  }
}
