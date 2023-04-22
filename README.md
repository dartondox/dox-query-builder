# Dart SQL Query Builder

```dart
void main() async {
  PostgreSQLConnection db = PostgreSQLConnection(
    'localhost',
    5432,
    'postgres',
    username: 'admin',
    password: 'password',
  );
  await db.open();
  Builder builder = Builder(db).debug(true);
  var admin = await builder.table('admin').find(1);
  print(admin);
}
```

## Type support
`insert()`, `get()`, `all()`, `find()` functions support type to return.

```dart
import 'package:sql_query_builder/sql_query_builder.dart';
import 'package:sql_query_builder/src/utils/json_key.dart';

class Admin {
  int? id;
  
  @JsonKey(name: 'name')
  String? adminName;

  @JsonKey(name: 'age', filter : parseAge)
  int? age;

  Admin({this.id, this.name, this.age});
}

String parseAge(val) {
  return int.parse(val);
}

Admin admin = await builder.table('admin').insert<Admin>(
  {'name': 'John Wick', 'age': 60}
);

print(admin.id)
print(admin.adminName)
print(admin.age)

List<Admin> admins = await builder.table('admin').get<Admin>();
List<Admin> admins = await builder.table('admin').all<Admin>();
Admin admin = await builder.table('admin').find<Admin>('name', 'John Wick');

```
`@JsonKey` is used to map database column name and class model;

### debug (this option will print query and query params in the console)

```dart
Builder builder = Builder(db).debug(true);
await builder.table('admin').find(1);
```

### insert

```dart
// single entry
await builder.table('admin').insert(
  {'name': 'John Wick', 'age': 60}
);

// multiple
await builder.table('admin').insertMultiple([
  {'name': 'John Wick', 'age': 60},
  {'name': 'John Doe', 'age': 25},
]);
```

### Update

```dart
await builder.table('admin')
  .where('id', 3)
  .where('status', 'active')
  .update({
    "name": "Updated AJ",
    "age": 120,
  });
```

### all

```dart
await builder.table('admin').all();
```

### count

```dart
await builder.table('admin').count();

await builder.table('admin').where('age', '>=' , 23).count();
```

### find

```dart
await builder.table('admin').find(id); // find by id

await builder.table('admin').find('name', 'John Wick');
```

### get

```dart
await builder.table('admin').where('name', 'John Wick').get();
```

### select

```dart
await builder.table('admin')
  .select('id')
  .select('name')
  .where('name', 'John Wick').get();

await builder.table('admin')
  .select(['id', 'name', 'age']).where('name', 'John Wick').get();

await builder.table('admin')
  .select('id, name, age').where('name', 'John Wick').get();
```

### where

```dart
// equal condition between column and value
await builder.table('admin').where('name', 'John Wick').get();

// custom condition between column and value
await builder.table('admin').where('name', '=', 'John Wick').get();
await builder.table('admin').where('age', '>=', 23).get();
```

### orWhere

```dart
// equal condition between column and value
await builder.table('admin').orWhere('name', 'John Wick').get();

// custom condition between column and value
await builder.table('admin').orWhere('name', '=', 'John Wick').get();
await builder.table('admin').orWhere('age', '>=', 23).get();
```

### whereRaw

```dart
await builder.table('admin').whereRaw('name = @name', {'name', 'John Wick'}).get();
```

### orWhereRaw

```dart
await builder.table('admin').orWhereRaw('name = @name', {'name', 'John Wick'}).get();
```

### Chain where and orWhere

```dart
await builder.table('admin')
  .where('name', 'John Doe').orWhere('name', 'John Wick').get();
```

### Chain where and orWhere

```dart
await builder.table('admin')
  .where('name', 'John Doe').orWhere('name', 'John Wick').get();
```

### limit or take

```dart
await builder.table('admin').limit(10).get();
// or
await builder.table('admin').take(10).get();
```

### offset

```dart
await builder.table('admin').limit(10).offset(10).get();
```

### groupBy

```dart
await builder.table('admin')
  .select('count(*) as total, name').groupBy('name').get();
```

### orderBy

```dart

// default order by with name column
await builder.table('admin').orderBy('name').get();

// order by column and type desc
await builder.table('admin').orderBy('name', 'desc').get();

// order by column and type asc
await builder.table('admin').orderBy('name', 'asc').get();

// multiple order by
await builder.table('admin')
  .orderBy('name', 'asc')
  .orderBy('id', 'desc')
  .get();
```

## Join

### join

```dart
var admin = await builder.table('admin')
    .join('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```

### leftJoin

```dart
var admin = await builder.table('admin')
    .leftJoin('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```

### rightJoin

```dart
var admin = await builder.table('admin')
    .rightJoin('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```


### joinRaw

```dart
var admin = await builder.table('admin')
    .joinRaw('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```


### leftJoinRaw

```dart
var admin = await builder.table('admin')
    .leftJoinRaw('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```

### rightJoinRaw

```dart
var admin = await builder.table('admin')
    .rightJoinRaw('admin_info', 'admin_info.admin_id', 'admin.id')
    .get();
```
