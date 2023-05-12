import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:test/test.dart';

import 'blog.model.dart';
import 'blog_info.model.dart';
import 'connection.dart';

void main() async {
  SqlQueryBuilder.initialize(database: await connection(), debug: false);

  group('Query Builder', () {
    setUp(() {});

    test('insert', () async {
      Schema.drop('blog');
      Schema.drop('blog_info');
      Schema.create('blog', (Table table) {
        table.id('uid');
        table.string('title');
        table.char('status').withDefault('active');
        table.text('body');
        table.string('slug').nullable();
        table.softDeletes();
        table.timestamps();
      });

      Schema.create('blog_info', (Table table) {
        table.id('id');
        table.json('info');
        table.integer('blog_id');
        table.timestamps();
      });

      Blog blog = Blog();
      blog.title = 'Awesome blog';
      blog.description = 'Awesome blog body';
      blog.status = 'deleted';
      await blog.save();
      blog.title = "Updated title";
      await blog.save();

      BlogInfo info = BlogInfo();
      info.info = {"name": "awesome"};
      info.blogId = blog.uid;
      await info.save();

      print(info.id);

      BlogInfo? blogInfo = await blog.blogInfo;

      Blog? b = await blogInfo?.blog;
      print(b?.uid);
      print(b?.title);

      BlogInfo? newInfo = await blog.blogInfo;

      print(newInfo?.id);
      print(newInfo?.info);

      expect(blog.uid != null, true);

      Blog blog2 = Blog();
      blog2.title = 'Amazing blog';
      blog2.description = 'Amazing blog body';
      blog2.status = 'active';
      await blog2.save();

      expect(blog2.uid != null, true);

      Blog result = await Blog().find(blog.uid);
      Blog result2 = await Blog().find(blog2.uid);

      expect(result.uid, blog.uid);
      expect(result.title, 'Updated title');
      expect(result.description, 'Awesome blog body');

      expect(result2.uid, blog2.uid);
      expect(result2.title, 'Amazing blog');
      expect(result2.description, 'Amazing blog body');

      await Blog().where('uid', blog.uid).delete();
      await Blog().where('uid', blog2.uid).delete();

      List<Blog> blogs = await Blog().withTrash().all();

      expect(blogs.length, 2);

      List blogs2 = await Blog().all();
      expect(blogs2.length, 0);
    });

    // test('test with new query', () async {
    //   Blog blog = Blog();
    //   blog.title = "new blog";
    //   blog.description = "something";
    //   await blog.save();

    //   Blog check = await blog.newQuery.find(blog.uid);
    //   expect(check.uid, blog.uid);
    // });

    // test('test to Sql', () async {
    //   Blog blog = Blog();
    //   blog.title = "new blog";
    //   blog.description = "something";
    //   await blog.save();

    //   expect(blog.uid != null, true);

    //   String query = blog.newQuery.where('uid', blog.uid).toSql();
    //   expect("SELECT * FROM blog WHERE uid = ${blog.uid}", query);
    // });

    // test('test toMap', () async {
    //   Blog blog = Blog();
    //   blog.title = "new blog";
    //   blog.description = "something";
    //   await blog.save();

    //   Map<String, dynamic> data = blog.toMap();
    //   expect(data['uid'], blog.uid);
    //   expect(data['title'], blog.title);
    // });

    // test('test toJson', () async {
    //   Blog blog = Blog();
    //   blog.title = "new blog";
    //   blog.description = "something";
    //   await blog.save();

    //   String data = blog.toJson();
    //   expect(true, data.contains('new blog'));
    // });

    // test('schema update', () async {
    //   await Schema.table('blog', (Table table) {
    //     table.renameColumn('title', 'blog_title');
    //     table.string('blog_title').nullable();
    //     table.string('body');
    //     table.string('slug').unique().nullable();
    //     table.string('column1').nullable();
    //     table.string('column2').nullable();
    //   });
    //   Table table = Table().table('blog');
    //   List columns = await table.getTableColumns();
    //   expect(true, columns.contains('uid'));
    //   expect(true, columns.contains('column1'));
    //   expect(true, columns.contains('column2'));
    //   expect(true, columns.contains('blog_title'));
    //   expect(true, columns.contains('slug'));
    // });
  });
}
