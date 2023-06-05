import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:test/test.dart';

import 'connection.dart';
import 'models/blog/blog.model.dart';

void main() {
  group('Model |', () {
    setUp(() async {
      SqlQueryBuilder.initialize(database: poolConnection(), debug: false);
      await Schema.create('blog', (Table table) {
        table.id('uid');
        table.string('title');
        table.char('status').withDefault('active');
        table.text('body');
        table.string('slug').nullable();
        table.softDeletes();
        table.timestamps();
      });

      await Schema.create('blog_info', (Table table) {
        table.id('id');
        table.json('info');
        table.integer('blog_id');
        table.timestamps();
      });

      await Schema.create('comment', (Table table) {
        table.id('id');
        table.string('comment').nullable();
        table.integer('blog_id');
        table.timestamps();
      });
    });

    tearDown(() async {
      await Schema.drop('blog');
      await Schema.drop('blog_info');
      await Schema.drop('comment');
    });

    test('create', () async {
      Blog blog = await Blog().create(<String, dynamic>{
        'title': 'dox query builder',
        'body': 'Best orm for the dart'
      });

      expect(blog.title, 'dox query builder');
      expect(blog.description, 'Best orm for the dart');
      expect(blog.uid, 1);
    });

    test('insert', () async {
      Blog blog = await Blog().insert(<String, dynamic>{
        'title': 'dox query builder',
        'body': 'Best orm for the dart'
      });

      expect(blog.title, 'dox query builder');
      expect(blog.description, 'Best orm for the dart');
      expect(blog.uid, 1);
    });

    test('insert multiple', () async {
      await Blog().insertMultiple(<Map<String, dynamic>>[
        <String, dynamic>{
          'title': 'dox query builder',
          'body': 'Best orm for the dart'
        },
        <String, dynamic>{
          'title': 'dox core',
          'body': 'dart web framework',
        }
      ]);

      int total = await Blog().count();
      expect(total, 2);
    });

    test('save', () async {
      Blog blog = Blog();
      blog.title = 'dox query builder';
      blog.description = 'Best Orm';
      await blog.save();

      expect(blog.uid, 1);
      expect(blog.title, 'dox query builder');
      expect(blog.description, 'Best Orm');
    });

    test('delete', () async {
      Blog blog = Blog();
      blog.title = 'dox query builder';
      blog.description = 'Best Orm';
      await blog.save();

      await blog.delete();

      int total = await Blog().count();
      expect(total, 0);
    });

    test('find', () async {
      Blog blog = Blog();
      blog.title = 'dox query builder';
      blog.description = 'Best Orm';
      await blog.save();

      Blog? findBlog = await Blog().find(blog.uid);
      expect(findBlog?.title, 'dox query builder');
      expect(findBlog?.uid, blog.uid);
    });

    test('find by column name', () async {
      Blog blog = Blog();
      blog.title = 'dox query builder';
      blog.description = 'Best Orm';
      await blog.save();

      Blog? findBlog = await Blog().find('title', 'dox query builder');
      expect(findBlog?.title, 'dox query builder');
      expect(findBlog?.uid, blog.uid);
    });

    test('where', () async {
      Blog blog = Blog();
      blog.title = 'dox query builder';
      blog.description = 'Best Orm';
      await blog.save();

      Blog? findBlog =
          await Blog().where('title', 'dox query builder').getFirst();
      expect(findBlog?.title, 'dox query builder');
      expect(findBlog?.uid, blog.uid);
    });

    test('or where', () async {
      Blog blog = Blog();
      blog.title = 'title 1';
      blog.description = 'Best Orm';
      await blog.save();

      Blog blog2 = Blog();
      blog2.title = 'title 2';
      blog2.description = 'Best Orm';
      await blog2.save();

      List<Blog> blogs = await Blog()
          .where('title', 'title 1')
          .orWhere('title', 'title 2')
          .get();

      expect(blogs.first.title, 'title 1');
      expect(blogs.last.title, 'title 2');
    });

    test('new query', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      Blog check = await blog.newQuery.find(blog.uid);
      expect(check.uid, blog.uid);
    });

    test('timestamp should return with date time format', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      expect(blog.createdAt is DateTime, true);
      expect(blog.updatedAt is DateTime, true);
    });

    test('toSql', () async {
      String query = Blog().where('uid', 1).toSql();
      expect("SELECT * FROM blog WHERE uid = 1 AND deleted_at IS NULL", query);
    });

    test('toMap', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      Map<String, dynamic> data = blog.toMap();
      expect(data['uid'], blog.uid);
      expect(data['title'], blog.title);
      expect(data['created_at'].toString().contains(':'), true);
    });

    test('toMap original value on save', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      Map<String, dynamic> data = blog.toMap(original: true);
      expect(data['uid'], blog.uid);
      expect(data['title'], blog.title);
      expect(data['created_at'].toString().contains(':'), true);
    });

    test('toMap original value on find', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      Blog findBlog =
          await Blog().select('*, title as something').find(blog.uid);

      Map<String, dynamic> data = findBlog.toMap(original: true);
      expect(data['something'], blog.title);
    });

    test('test toJson', () async {
      Blog blog = Blog();
      blog.title = "new blog";
      blog.description = "something";
      await blog.save();

      Map<String, dynamic> data = blog.toJson();
      expect(data['uid'], blog.uid);
      expect(data['title'], blog.title);
      expect(data['created_at'].toString().contains(':'), true);
    });
  });
}
