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

  await Actor().where('id', 3).where('status', 'active').update({
    "name": "Updated Name",
    "age": 20,
  });
}
