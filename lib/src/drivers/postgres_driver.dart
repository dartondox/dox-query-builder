import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:postgres_pool/postgres_pool.dart';

class PostgresDriver extends DBDriver {
  final dynamic conn;

  PostgresDriver({this.conn});

  @override
  Future<List<Map<String, Map<String, dynamic>>>> mappedResultsQuery(
      String query,
      {Map<String, dynamic>? substitutionValues}) async {
    if (conn == null) {
      throw 'PostgreSQLConnection or PgPool connection required';
    }
    if (conn is PostgreSQLConnection) {
      return await (conn as PostgreSQLConnection)
          .transaction((PostgreSQLExecutionContext c) async {
        return await c.mappedResultsQuery(query,
            substitutionValues: substitutionValues);
      });
    } else {
      return await (conn as PgPool).run((PostgreSQLExecutionContext c) async {
        return await c.mappedResultsQuery(query,
            substitutionValues: substitutionValues);
      });
    }
  }

  @override
  Future<void> query(String query,
      {Map<String, dynamic>? substitutionValues}) async {
    if (conn is PostgreSQLConnection) {
      return await (conn as PostgreSQLConnection)
          .transaction((PostgreSQLExecutionContext c) async {
        await c.query(query, substitutionValues: substitutionValues);
        return;
      });
    } else {
      return await (conn as PgPool).run((PostgreSQLExecutionContext c) async {
        await c.query(query, substitutionValues: substitutionValues);
        return;
      });
    }
  }
}
