import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class Config {
  static final HttpLink httpLink =
      HttpLink("https://qvkfcrtycfypnyqgkdrf.hasura.eu-west-2.nhost.run/v1/graphql");
  static String? _token;
  static final AuthLink authLink = AuthLink(
    getToken: () => _token,
  );

  static final WebSocketLink webSocketLink = WebSocketLink(
    "https://qvkfcrtycfypnyqgkdrf.hasura.eu-west-2.nhost.run/v1/graphql",
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
      initialPayload: () async {
        return {
          // 'headers': {'Authorization': 'Bearer $_token'}
          'headers': {'x-hasura-admin-secret': '^1&a06vJJo4uf%UJzlxOn%p2dJdwae4h'}
        };
      },
    ),
  );

  static final Link link = authLink.concat(webSocketLink);

  static String? token;

  static Future<GraphQLClient> initializeClient(
      String token) async {
    await Hive.initFlutter();
    final box = await Hive.openBox<Map<String, dynamic>>('graphql');
    await box.clear();
    final store = HiveStore(box);
    _token = token;
    GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(store: store),
      link: link,
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.networkOnly,
          error: ErrorPolicy.none,
        ),
      ),
    );
    return client;
  }
}
