import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:test/test.dart';

import 'blog.model.dart';
import 'connection.dart';

void main() async {
  SqlQueryBuilder.initialize(database: await connection(), debug: false);

  group('Query Builder', () {
    setUp(() {});

    test('insert', () async {
      Schema.drop('blog');
      Schema.create('blog', (Table table) {
        table.id();
        table.string('title');
        table.char('status').withDefault('active');
        table.text('body');
        table.string('slug').nullable();
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
      await blog.save();

      Blog check = await blog.newQuery.find(blog.id);
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

    test('schema update', () async {
      await Schema.table('blog', (Table table) {
        table.renameColumn('title', 'blog_title');
        table.string('blog_title').nullable();
        table.string('body');
        table.string('slug').unique().nullable();
        table.string('column1').nullable();
        table.string('column2').nullable();
      });
      Table table = Table().table('blog');
      List columns = await table.getTableColumns();
      expect(true, columns.contains('id'));
      expect(true, columns.contains('column1'));
      expect(true, columns.contains('column2'));
      expect(true, columns.contains('blog_title'));
      expect(true, columns.contains('slug'));
    });
  });
}
