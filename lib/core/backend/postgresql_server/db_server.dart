import 'package:crabpay/core/backend/postgresql_server/access_config.dart';
import 'package:postgres/postgres.dart';

class DbServer {
  static final DbServer _instance = DbServer._internal();
  factory DbServer() => _instance;
  DbServer._internal();

  Pool? _pool;

  Future<Pool> get _getPool async {
    if (_pool?.isOpen ?? false) {
      return _pool!;
    }
    print('Initializing db connection');
    _pool = Pool.withEndpoints(
      [accessConfing],
      settings: const PoolSettings(
        maxConnectionCount: 5,
        maxConnectionAge: Duration(seconds: 5),
        sslMode: SslMode.verifyFull,
      ),
    );
    return _pool!;
  }

  Future<Result> execute(
    String query, {
    Map<String, Object>? parameters,
  }) async {
    final pool = await _getPool;

    try {
      if (parameters?.isNotEmpty ?? false) {
        return await pool.execute(Sql.named(query), parameters: parameters);
      } else {
        return await pool.execute(query);
      }
    } catch (e) {
      print('Database execution error: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    if (_pool?.isOpen ?? false) {
      await _pool!.close();
      print('Database pool is closed');
    }
  }
}
