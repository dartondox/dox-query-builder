# Dart SQL Query Builder

## [Documentation](https://dsqb.zinkyawkyaw.dev/)

## Example Usage

```dart
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

  // and finally use model from anywhere in the project.
  Actor actor = Actor();
  actor.actorName = 'John Wick';
  actor.age = 60;
  await actor.save();

  actor.actorName = "Tom Cruise";
  await actor.save(); // save again

  print(actor.id);

  Actor result = await Actor().where('name', 'Tom Cruise').get();
  print(result.age);
}
```
