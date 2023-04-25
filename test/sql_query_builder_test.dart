import 'package:sql_query_builder/sql_query_builder.dart';
import 'package:test/test.dart';

import 'connection.dart';

void main() async {
  SqlQueryBuilder.initialize(database: await connection(), debug: false);

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

      expect(blog.id != null, true);

      Blog blog2 = Blog();
      blog2.title = 'Amazing blog';
      blog2.description = 'Amazing blog body';
      blog2.status = 'active';
      await blog2.save();

      expect(blog2.id != null, true);

      Blog result = await Blog().find(blog.id);
      Blog result2 = await Blog().find(blog2.id);

      expect(result.id, blog.id);
      expect(result.title, 'Updated title');
      expect(result.description, 'Awesome blog body');

      expect(result2.id, blog2.id);
      expect(result2.title, 'Amazing blog');
      expect(result2.description, 'Amazing blog body');

      await Blog().where('id', blog.id).delete();
      await Blog().where('id', blog2.id).delete();

      List blogs = await Blog().withTrash().all();
      expect(blogs.length, 2);

      List blogs2 = await Blog().all();
      expect(blogs2.length, 0);
    });

    test('test with new query', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      blog.save();

      Blog check = await blog.newQuery.find(1);
      expect(check.id, blog.id);
    });

    test('test to Sql', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      expect(blog.id != null, true);

      String query = blog.newQuery.where('id', blog.id).toSql();
      expect("SELECT * FROM blog WHERE id = ${blog.id}", query);
    });

    test('test toMap', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      Map<String, dynamic> data = blog.toMap();
      expect(data['id'], blog.id);
      expect(data['title'], blog.title);
    });

    test('test toJson', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      String data = blog.toJson();
      expect(true, data.contains('new blog'));
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

  @Column(name: 'deleted_at')
  DateTime? deletedAt;

  @Column(name: 'created_at')
  DateTime? createdAt;

  @Column(name: 'updated_at')
  DateTime? updatedAt;
}
