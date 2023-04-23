import 'package:postgres/postgres.dart';
import 'package:sql_query_builder/sql_query_builder.dart';

void main() async {
  PostgreSQLConnection db = PostgreSQLConnection("localhost", 5432, "postgres",
      username: "admin", password: "password");

  SqlQueryBuilder.initialize(database: db, debug: true);

  List users = await QueryBuilder.table('users').all();
}
