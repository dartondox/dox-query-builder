#### Dart SQL Query Builder

- [Example Usage](#example-usage)
- [Schema](#schema-to-create-database-table)
  - [Create](#create-table)
  - [Drop](#dropdelete-table)
- [Model](#model)
  - [Structure](#model)
  - [Soft Deletes](#soft-deletes)
- [Query](#query)
  - [Insert or Create](#insert-or-create)
  - [Update](#update)
  - [Count](#count)
  - [Find](#find)
  - [All](#all)
  - [Get](#get)
  - [Delete](#delete)
  - [Force delete](#forcedelete-only-with-softdeletes)
  - [With trash](#withtrash-only-with-softdeletes)
  - [Select](#select)
  - [Where](#where)
  - [Where raw](#whereraw)
  - [OrWhere](#orwhere)
  - [OrWhere raw](#orwhereraw)
  - [Chain where and orWhere](#chain-where-and-orwhere)
  - [Chain where and orWhere](#chain-where-and-orwhere)
  - [Limit or Take](#limit-or-take)
  - [Offset](#offset)
  - [Group By](#groupby)
  - [Order By](#orderby)
  - [Join](#join)
  - [Join raw](#joinraw)
  - [Left Join](#leftjoin)
  - [Left Join raw](#leftjoinraw)
  - [Right Join](#rightjoin)
  - [Right Join raw](#rightjoinraw)
- [Development](#development)

##### Example Usage

```dart
import 'package:sql_query_builder/sql_query_builder.dart';

// create a model
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
  actor.name = 'John Wick';
  actor.age = 60;
  await actor.save();

  actor.name = "Tom Cruise";
  await actor.save(); // save again

  print(actor.id)

  Actor result = Actor().where('name', 'Tom Cruise').get();
  print(result.status)
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

##### Join Query

###### join

```dart
await Actor()
    .join('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```

###### leftJoin

```dart
await Actor()
    .leftJoin('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```

###### rightJoin

```dart
await Actor()
    .rightJoin('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```

###### joinRaw

```dart
await Actor()
    .joinRaw('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```

###### leftJoinRaw

```dart
await Actor()
    .leftJoinRaw('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```

###### rightJoinRaw

```dart
await Actor()
    .rightJoinRaw('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```

#### Development
Want to contribute? Great! Fork the repo and create PR to us.
