import 'package:crabpay/core/backend/postgresql_server/db_server.dart';

class PostgreSQLSchema {
  Future<void> creeateTable(String tableToCreate) async {
    final dbServer = DbServer();
    final Map<String, String> tables = {
      'productTable': _productTable,
      'productFieldTable': _productFieldTable,
      'currencyTable': _currencyTable,
      'cartItemTable': _cartItemTable,
      'userPreferenceTable': _userPreferenceTable,
      'featuredProductTable': _featuredProductTable,
      'userCartItemCountView': _userCartItemCountView,
      'ofUserOfProductCartItemCounter': _ofUserOfProductCartItemCounter,
    };
    for (var table in tables.values) {
      await dbServer.execute(table);
    }
  }

  final String _productTable = '''
    CREATE TABLE IF NOT EXISTS product (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      image_url TEXT NOT NULL,
      currencies TEXT NOT NULL DEFAULT 'rubDefault'
    );
    ''';

  final String _productFieldTable = '''
    CREATE TABLE IF NOT EXISTS product_field (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      product_id UUID NOT NULL REFERENCES product(id) ON DELETE CASCADE,
      "order" INTEGER NOT NULL,
      field_name TEXT NOT NULL,
      is_price_image BOOLEAN NOT NULL DEFAULT FALSE,
      handler TEXT NOT NULL,
      price_images JSONB,
      expected_data TEXT[]
    );
    ''';

  final String _currencyTable = '''
    CREATE TABLE IF NOT EXISTS currencies (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      name TEXT NOT NULL,
      main_currency TEXT NOT NULL,
      rub NUMERIC NOT NULL,
      usd NUMERIC NOT NULL
    );
    ''';

  final String _cartItemTable = '''
    CREATE TABLE IF NOT EXISTS cart_item (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id TEXT NOT NULL,
      user_name TEXT NOT NULL,
      product_id UUID NOT NULL REFERENCES product(id) ON DELETE CASCADE,
      product_name TEXT NOT NULL,
      purchase_data JSONB NOT NULL,
      currency TEXT NOT NULL,
      checkout_price NUMERIC NOT NULL,
      created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
      status TEXT NOT NULL,
      comment TEXT,
      status_changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    ''';

  final String _userPreferenceTable = '''
    CREATE TABLE IF NOT EXISTS user_preference (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id TEXT NOT NULL,
      favorite_product_id UUID REFERENCES product(id) ON DELETE SET NULL
    );
    ''';

  final String _featuredProductTable = '''
    CREATE TABLE IF NOT EXISTS featured_product (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      featured_product_id UUID REFERENCES product(id) ON DELETE CASCADE
    );
    ''';

  final String _userCartItemCountView = '''
    CREATE OR REPLACE VIEW of_user_cart_item_counter AS
    SELECT 
      user_id, 
      COUNT(*)::int AS user_cart_item_count
    FROM cart_item
    GROUP BY user_id;
    ''';
  final String _ofUserOfProductCartItemCounter = '''
    CREATE OR REPLACE VIEW of_user_of_product_cart_item_counter AS
    SELECT 
      user_id, 
      product_id, 
      COUNT(*)::int AS product_cart_item_count
    FROM cart_item
    GROUP BY user_id, product_id;
    ''';
}
