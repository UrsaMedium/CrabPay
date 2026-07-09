import 'package:crabpay/core/backend/supabase/supabase_conf.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseGraphQLClient {
  static GraphQLClient get client {
    // Point to your Nginx proxy GraphQL endpoint
    final HttpLink httpLink = HttpLink(
      '${supabaseAccessConf['url']}/graphql/v1',
      defaultHeaders: {
        'apiKey': supabaseAccessConf['publishableKey']!,
      },
    );

    // Dynamically fetch the current session token for RLS
    final AuthLink authLink = AuthLink(
      getToken: () async {
        final session = Supabase.instance.client.auth.currentSession;
        // Fallback to the publishable anon key if the user is not logged in
        return session != null 
            ? 'Bearer ${session.accessToken}' 
            : 'Bearer ${supabaseAccessConf['publishableKey']!}';
      },
    );

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: authLink.concat(httpLink),
    );
  }
}