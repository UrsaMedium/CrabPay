import 'package:crabpay/core/backend/supabase/supabase_conf.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

HttpLink createSupabaseGraphQLConfig() {
  return HttpLink(
    'https://supabase.regred-rainbowbridge.ru/graphql/v1',
    defaultHeaders: {
      // 1. Fetch directly from your config map
      'apiKey': supabaseAccessConf['publishableKey']!,
      
      // 2. Dynamically attach the active JWT user token or default to the publishable key
      'Authorization': 'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken ?? supabaseAccessConf['publishableKey']!}',
    },
  );
}