import 'package:dox_query_builder/dox_query_builder.dart';

class SqlQueryBuilder {
  static final SqlQueryBuilder _singleton = SqlQueryBuilder._internal();

  factory SqlQueryBuilder() {
    return _singleton;
  }

  SqlQueryBuilder._internal();

  DBDriver db = PostgresDriver();

  bool debug = true;

  static void initialize({required dynamic database, bool? debug}) {
    SqlQueryBuilder sql = SqlQueryBuilder();
    sql.db = PostgresDriver(conn: database);
    sql.debug = debug ?? false;
  }
}
