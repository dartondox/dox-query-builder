import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:sql_query_builder/sql_query_builder.dart';
import 'package:sql_query_builder/src/schema.dart';
import 'package:sql_query_builder/src/schema/table.dart';
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
      Schema schema = Schema(db).debug(false);

      schema.drop('blog');
      schema.create('blog', (Table table) {
        table.id();
        table.string('title').nullable().unique();
        table.char('status').withDefault('active');
        table.text('body');
        table.money('amount').nullable();
        table.softDeletes();
        table.timestamps();
      });
      builder.table('blog').truncate();
      await builder.table('blog').insert({
        'title': 'Awesome blog',
        'body': 'Awesome blog body',
      });
      var blog = await builder.table('blog').find(1);
      expect(blog['id'], 1);
      expect(blog['title'], 'Awesome blog');
      expect(blog['body'], 'Awesome blog body');
    });
  });
}
