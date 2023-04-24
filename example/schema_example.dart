import 'package:postgres/postgres.dart';
import 'package:sql_query_builder/sql_query_builder.dart';

void main() async {
  // create database connection and open
  PostgreSQLConnection db = PostgreSQLConnection(
    'localhost',
    5432,
    'postgres',
    username: 'admin',
    password: 'password',
  );
  await db.open();

  // initialize SqlQueryBuilder, only once at main function
  SqlQueryBuilder.initialize(database: db, debug: true);

  Schema.create('blog', (Table table) {
    table.id();
    table.string('slug').unique();
    table.string('title').nullable();
    table.char('status').withDefault('active');
    table.text('body');
    table.money('amount').nullable();
    table.softDeletes();
    table.timestamps();
  });
}
