import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:test/test.dart';

import 'connection.dart';
import 'models/blog/blog.model.dart';
import 'models/blog_info/blog_info.model.dart';

void main() async {
  SqlQueryBuilder.initialize(database: await connection(), debug: false);

  group('Query Builder', () {
    setUp(() {
      Schema.drop('blog');
      Schema.drop('blog_info');
      Schema.drop('comment');
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

      Schema.create('comment', (Table table) {
        table.id('id');
        table.string('comment').nullable();
        table.integer('blog_id');
        table.timestamps();
      });
    });

    test('insert', () async {
      Blog blog = Blog();
      blog.title = 'Awesome blog';
      blog.description = 'Awesome blog body';
      blog.status = 'deleted';
      await blog.save();
      blog.title = "Updated title";
      await blog.save();

      BlogInfo info = BlogInfo();
      info.info = <String, String>{"name": "awesome"};
      info.blogId = blog.uid;
      await info.save();

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

      Blog findTrash = await Blog().withTrash().find(blog.uid);
      expect(findTrash.deletedAt is DateTime, true);

      List<Blog> blogs2 = await Blog().all();
      expect(blogs2.length, 0);
    });

    test('test with new query', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      expect(blog.createdAt is DateTime, true);
      expect(blog.updatedAt is DateTime, true);

      Blog check = await blog.newQuery.find(blog.uid);
      expect(check.uid, blog.uid);
    });

    test('test to Sql', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      expect(blog.uid != null, true);

      String query = blog.newQuery.where('uid', blog.uid).toSql();
      expect(
          "SELECT * FROM blog WHERE uid = ${blog.uid} AND deleted_at IS NULL",
          query);
    });

    test('test toMap', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      Map<String, dynamic> data = blog.toMap();
      expect(data['uid'], blog.uid);
      expect(data['title'], blog.title);
      expect(data['created_at'].toString().contains(':'), true);
    });

    test('test toJson', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      Map<String, dynamic> data = blog.toJson();
      expect(true, data['title'].contains('new blog'));
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
      List<String> columns = await table.getTableColumns();
      expect(true, columns.contains('uid'));
      expect(true, columns.contains('column1'));
      expect(true, columns.contains('column2'));
      expect(true, columns.contains('blog_title'));
      expect(true, columns.contains('slug'));
    });

    test('hasOne', () async {
      Blog blog = Blog();
      blog.title = 'Awesome blog';
      blog.description = 'Awesome blog body';
      await blog.save();

      BlogInfo blogInfo = BlogInfo();
      blogInfo.info = <String, String>{"name": "awesome"};
      blogInfo.blogId = blog.uid;
      await blogInfo.save();

      await blog.reload();
      expect(blog.blogInfo?.info?['name'], 'awesome');
    });

    test('belongsTo', () async {
      Blog blog = Blog();
      blog.title = 'Awesome blog';
      blog.description = 'Awesome blog body';
      await blog.save();

      BlogInfo blogInfo = BlogInfo();
      blogInfo.info = <String, String>{"name": "awesome"};
      blogInfo.blogId = blog.uid;
      await blogInfo.save();

      BlogInfo info = await BlogInfo().preload('blog').getFirst();
      expect(info.blog?.title, 'Awesome blog');

      BlogInfo info2 = await BlogInfo().getFirst();
      await info2.$getRelation('blog');
      expect(info2.blog?.title, 'Awesome blog');

      BlogInfo info3 = await BlogInfo().getFirst();
      Blog? b = await info3.related<Blog>('blog')?.getFirst();
      expect(b?.title, 'Awesome blog');
    });

    test('hasMany', () async {
      Blog blog = Blog();
      blog.title = 'Awesome blog';
      blog.description = 'Awesome blog body';
      await blog.save();

      BlogInfo blogInfo = BlogInfo();
      blogInfo.info = <String, String>{"name": "awesome"};
      blogInfo.blogId = blog.uid;
      await blogInfo.save();

      await blog.reload();

      expect(blog.blogInfos.first.info?['name'], 'awesome');
    });

    test('eager load', () async {
      Blog blog = Blog();
      blog.title = 'Awesome blog';
      blog.description = 'Awesome blog body';
      await blog.save();

      BlogInfo blogInfo = BlogInfo();
      blogInfo.info = <String, String>{"name": "dox"};
      blogInfo.blogId = blog.uid;
      await blogInfo.save();

      Blog b = await Blog().getFirst();
      expect(b.blogInfo?.info?['name'], 'dox');
    });

    test('test query builder with map result', () async {
      Blog blog = Blog();
      blog.title = 'Awesome blog';
      blog.description = 'Awesome blog body';
      await blog.save();

      Map<String, dynamic> b = await QueryBuilder.table('blog')
          .where('title', 'Awesome blog')
          .getFirst();

      expect(b['uid'], 1);
    });
  });
}
