import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:sql_query_builder/sql_query_builder.dart';
import 'package:sql_query_builder/src/utils/json_key.dart';
import 'package:test/test.dart';

void main() async {
  String host = Platform.environment['DB_HOST'] ?? 'postgres';
  int port = int.parse(Platform.environment['PORT'] ?? '5432');
  PostgreSQLConnection db = PostgreSQLConnection(
    host,
    port,
    "postgres",
    username: "admin",
    password: "password",
  );
  await db.open();
  Builder builder = Builder(db).debug(false);

  group('Query Builder', () {
    setUp(() {});

    test('insert', () async {
      builder.table('admin').truncate();

      await builder.table('admin').insert({
        'name': 'John Doe',
        'age': '28',
      });

      await builder.table('admin').insert({
        'name': 'John Wrick',
        'age': '32',
      });

      List<Admin> admins = await builder.table('admin').all<Admin>();

      for (Admin admin in admins) {
        print(admin.id);
        print(admin.name);
        print(admin.yearOld);
      }
    });
  });
}

String ageFilter(val) {
  return "$val years old";
}

List idFilter(id) {
  return ["ID : $id"];
}

class Admin {
  @JsonKey(name: 'id', filter: idFilter)
  dynamic id;

  String? name;

  @JsonKey(
    name: 'age',
    filter: ageFilter,
  )
  String? yearOld;

  Admin(this.id, this.name, this.yearOld);
}
