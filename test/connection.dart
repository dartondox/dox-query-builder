import 'dart:io';

import 'package:postgres/postgres.dart';

connection() async {
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
  return db;
}
