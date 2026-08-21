enum ServerConnectionStatus { initial, connecting, online, offline }

abstract class InnerConnectionMonitor {
  Stream<ServerConnectionStatus> get statusStream;

  ServerConnectionStatus get currentStatus;

  void dispose();
}
