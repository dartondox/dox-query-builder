import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:sql_query_builder/sql_query_builder.dart';

import 'test/blog.model.dart';

void main(List<String> args) async {
  String host = Platform.environment['DB_HOST'] ?? 'localhost';
  int port = int.parse(Platform.environment['PORT'] ?? '5432');
  PostgreSQLConnection db = PostgreSQLConnection(
    host,
    port,
    "postgres",
    username: "admin",
    password: "password",
  );
  await db.open();

  SqlQueryBuilder.initialize(database: db);

  Blog blog = Blog();
  blog.title = 'Awesome blog';
  blog.description = 'Awesome blog body';
  blog.status = 'deleted';
  await blog.save();
  blog.title = "Updated title";
  await blog.save();

  db.close();
}
