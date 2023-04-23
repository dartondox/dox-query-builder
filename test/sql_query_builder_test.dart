import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:sql_query_builder/sql_query_builder.dart';
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
  SqlQueryBuilder.initialize(database: db, debug: false);

  group('Query Builder', () {
    setUp(() {});

    test('insert', () async {
      Schema.drop('blog');
      Schema.create('blog', (Table table) {
        table.id();
        table.string('title').nullable();
        table.char('status').withDefault('active');
        table.text('body');
        table.money('amount').nullable();
        table.softDeletes();
        table.timestamps();
      });

      Blog blog = Blog();
      blog.title = 'Awesome blog';
      blog.description = 'Awesome blog body';
      blog.status = 'deleted';
      await blog.save();
      blog.title = "Updated title";
      await blog.save();

      Blog blog2 = Blog();
      blog2.title = 'Amazing blog';
      blog2.description = 'Amazing blog body';
      blog2.status = 'active';
      await blog2.save();

      Blog result = await Blog().find(1);
      Blog result2 = await Blog().find(2);

      expect(result.id, 1);
      expect(result.title, 'Updated title');
      expect(result.description, 'Awesome blog body');

      expect(result2.id, 2);
      expect(result2.title, 'Amazing blog');
      expect(result2.description, 'Amazing blog body');

      await Blog().where('id', 1).delete();
      await Blog().where('id', 2).delete();

      List blogs = await Blog().withTrash().all();
      expect(blogs.length, 2);

      List blogs2 = await Blog().all();
      expect(blogs2.length, 0);
    });
  });
}

class Blog extends Model with SoftDeletes {
  @override
  String get primaryKey => 'id';

  @Column(name: 'id')
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
