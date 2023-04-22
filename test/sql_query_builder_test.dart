import 'package:postgres/postgres.dart';
import 'package:sql_query_builder/sql_query_builder.dart';
import 'package:test/test.dart';

void main() {
  PostgreSQLConnection db = PostgreSQLConnection(
    "postgres",
    5432,
    "postgres",
    username: "admin",
    password: "password",
  );
  var queryBuilder = QueryBuilder(db);

  group('A group of tests', () {
    setUp(() {});

    test('First Test', () async {
      var admin = await queryBuilder
          .debug(true)
          .table('admin')
          .join('admin_info', 'admin_info.admin_id', 'admin.id')
          .get();
      print(admin);
    });
  });
}
