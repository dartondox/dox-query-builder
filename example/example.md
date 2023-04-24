#### Dart SQL Query Builder

- [Dart SQL Query Builder](#dart-sql-query-builder)
  - [Example Usage](#example-usage)
- [Schema (to create database table)](#schema-to-create-database-table)
    - [create table](#create-table)
    - [drop/delete table](#dropdelete-table)
- [Model](#model)
    - [Soft Deletes](#soft-deletes)
    - [Save](#save)
    - [Debug](#debug)
    - [Reset query and create new one](#reset-query-and-create-new-one)
- [Query](#query)
    - [insert or create](#insert-or-create)
    - [update](#update)
    - [count](#count)
    - [find](#find)
    - [all](#all)
    - [get](#get)
    - [toSql](#tosql)
    - [delete](#delete)
    - [forceDelete (only with SoftDeletes)](#forcedelete-only-with-softdeletes)
    - [withTrash (only with SoftDeletes)](#withtrash-only-with-softdeletes)
    - [select](#select)
    - [where](#where)
    - [orWhere](#orwhere)
    - [whereRaw](#whereraw)
    - [orWhereRaw](#orwhereraw)
    - [chain where and orWhere](#chain-where-and-orwhere)
    - [limit or take](#limit-or-take)
    - [offset](#offset)
    - [groupBy](#groupby)
    - [orderBy](#orderby)
    - [join](#join)
    - [leftJoin](#leftjoin)
    - [rightJoin](#rightjoin)
    - [joinRaw](#joinraw)
    - [leftJoinRaw](#leftjoinraw)
    - [rightJoinRaw](#rightjoinraw)
    - [debug](#debug-1)
  - [Custom Query Builder Without Model](#custom-query-builder-without-model)
- [Development](#development)

##### Example Usage

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

#### Schema (to create database table)

###### create table

```dart
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
```

###### drop/delete table

```dart
Schema.drop('blog');
```

#### Model

```dart
class Blog extends Model {
  @override
  String get primaryKey => 'id';

  @Column()
  int? id;

  @Column()
  String? title;

  @Column()
  String? status;

  @Column(name: 'body')
  String? description;

  @Column(name: 'created_at')
  DateTime? createdAt;

  @Column(name: 'updated_at')
  DateTime? updatedAt;
}
```

- `String get primaryKey` is optional default is `id`
- use `@Column` annotation to declare an attribute as a database column
- `@Column` support `name` (database key)

###### Soft Deletes

```dart
class Blog extends Model with SoftDeletes {
 // columns here
}
```

###### Save

```dart
Actor actor = Actor();
actor.name = 'John Wick';
actor.age = 60;
await actor.save();
```
###### Debug

```dart
Actor actor = Actor();
actor.name = 'John Wick';
actor.age = 60;
actor.debug(true);
await actor.save();
```

###### Reset query and create new one

- If you do not want to create new class and reuse existing class to do new query, use can use `newQuery` attribute.

```dart
List blog = Blog().where('status', 'active').where('user', 'super_user').get();

// reset existing get query and make new one using `newQuery`
List blog = await blog.newQuery.where('status', 'deleted').where('user', 'normal').get();
```

#### Query

###### insert or create

```dart
// single entry
await Actor().create(
  {'name': 'John Wick', 'age': 60}
);

await Actor().insert(
  {'name': 'John Wick', 'age': 60}
);

// multiple
await Actor().insertMultiple([
  {'name': 'John Wick', 'age': 60},
  {'name': 'John Doe', 'age': 25},
]);
```

###### update

```dart
await Actor()
  .where('id', 3)
  .where('status', 'active')
  .update({
    "name": "Updated AJ",
    "age": 120,
  });
```

###### count

```dart
await Actor().count();

await Actor().where('age', '>=' , 23).count();
```

###### find

```dart
await Actor().find(id); // find by id

await Actor().find('name', 'John Wick');
```

###### all

```dart
List actors = await Actor().all();
for(Actor actor in actors) {
  print(actor.id)
}
```

###### get

```dart
List actors = await Actor().where('name', 'John Wick').get();
for(Actor actor in actors) {
  print(actor.id)
}
```

###### toSql

```dart
String query = Actor().where('name', 'John Wick').toSql();
print(query)
```

_NOTE:: currently there is an ongoing issue with List type_

```dart
List<Actor> actors = await Actor().where('name', 'John Wick').get(); // will throw error
```

###### delete

```dart
await Actor().where('name', 'John Wick').delete();
```

###### forceDelete (only with SoftDeletes)

```dart
await Actor().where('name', 'John Wick').forceDelete();
```

###### withTrash (only with SoftDeletes)

```dart
List actors = await Actor().where('name', 'John Wick').withTrash().get();
for(Actor actor in actors) {
  print(actor.id)
}
```

###### select

```dart
await Actor()
  .select('id')
  .select('name')
  .where('name', 'John Wick').get();

await Actor()
  .select(['id', 'name', 'age']).where('name', 'John Wick').get();

await Actor()
  .select('id, name, age').where('name', 'John Wick').get();
```

###### where

```dart
// equal condition between column and value
await Actor().where('name', 'John Wick').get();

// custom condition between column and value
await Actor().where('name', '=', 'John Wick').get();
await Actor().where('age', '>=', 23).get();
```

###### orWhere

```dart
// equal condition between column and value
await Actor().orWhere('name', 'John Wick').get();

// custom condition between column and value
await Actor().orWhere('name', '=', 'John Wick').get();
await Actor().orWhere('age', '>=', 23).get();
```

###### whereRaw

```dart
await Actor().whereRaw('name = @name', {'name', 'John Wick'}).get();
```

###### orWhereRaw

```dart
await Actor().orWhereRaw('name = @name', {'name', 'John Wick'}).get();
```

###### chain where and orWhere

```dart
await Actor()
  .where('name', 'John Doe').orWhere('name', 'John Wick').get();
```

###### limit or take

```dart
await Actor().limit(10).get();
// or
await Actor().take(10).get();
```

###### offset

```dart
await Actor().limit(10).offset(10).get();
```

###### groupBy

```dart
await Actor()
  .select('count(*) as total, name').groupBy('name').get();
```

###### orderBy

```dart

// default order by with name column
await Actor().orderBy('name').get();

// order by column and type desc
await Actor().orderBy('name', 'desc').get();

// order by column and type asc
await Actor().orderBy('name', 'asc').get();

// multiple order by
await Actor()
  .orderBy('name', 'asc')
  .orderBy('id', 'desc')
  .get();
```

###### join

```dart
await Actor()
    .join('actor_info', 'actor_info.admin_id', 'admin.id')
    .get();
```

###### leftJoin

```dart
await Actor()
    .leftJoin('actor_info', 'actor_info.admin_id', 'admin.id')
    .get();
```

###### rightJoin

```dart
await Actor()
    .rightJoin('actor_info', 'actor_info.admin_id', 'admin.id')
    .get();
```

###### joinRaw

```dart
await Actor()
    .joinRaw('actor_info', 'actor_info.admin_id', 'admin.id')
    .get();
```

###### leftJoinRaw

```dart
await Actor()
    .leftJoinRaw('actor_info', 'actor_info.admin_id', 'admin.id')
    .get();
```

###### rightJoinRaw

```dart
await Actor()
    .rightJoinRaw('actor_info', 'actor_info.admin_id', 'admin.id')
    .get();
```

###### debug

```dart
await Actor().debug(true).all();
```

##### Custom Query Builder Without Model

```dart
await QueryBuilder.table('actor').get();
```

#### Development
Want to contribute? Great! Fork the repo and create PR to us.
