import 'package:postgres/postgres.dart';
import 'package:sql_query_builder/sql_query_builder.dart';

class Actor extends Model {
  @override
  String get primaryKey => 'id';

  @Column()
  int? id;

  @Column(name: 'name')
  String? actorName;

  @Column()
  int? age;

  @Column(name: 'created_at')
  DateTime? createdAt;

  @Column(name: 'updated_at')
  DateTime? updatedAt;
}

void main(List<String> args) async {
  // create database connection and open
  PostgreSQLConnection db = PostgreSQLConnection(
    'localhost',
    5432,
    'postgres',
    username: 'admin',
    password: 'password',
  );
  await db.open();
  // single entry
  await Actor().create({'name': 'John Wick', 'age': 60});

  await Actor().insert({'name': 'John Wick', 'age': 60});

  // multiple
  await Actor().insertMultiple([
    {'name': 'John Wick', 'age': 60},
    {'name': 'John Doe', 'age': 25},
  ]);
}
