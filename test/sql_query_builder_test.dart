import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:test/test.dart';

import 'connection.dart';
import 'models/blog/blog.model.dart';

void main() async {
  SqlQueryBuilder.initialize(database: poolConnection(), debug: false);

  group('Query Builder', () {
    setUp(() async {
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

    test('truncate', () async {
      Blog blog = Blog();
      blog.title = 'Awesome blog';
      blog.description = 'Awesome blog body';
      await blog.save();

      await Blog().truncate();
      int total = await Blog().count();
      expect(total, 0);
    });

    test('limit', () async {
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

      List<Blog> blogs = await Blog().limit(1).get();
      expect(blogs.length, 1);

      List<Blog> blogs2 = await Blog().limit(2).get();
      expect(blogs2.length, 2);

      List<Blog> blogs3 = await Blog().take(1).get();
      expect(blogs3.length, 1);

      List<Blog> blogs4 = await Blog().take(2).get();
      expect(blogs4.length, 2);
    });

    test('offset', () async {
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

      List<Blog> blog = await Blog().offset(0).limit(1).get();
      expect(blog.first.title, 'dox query builder');

      List<Blog> blog2 = await Blog().offset(1).limit(1).get();
      expect(blog2.first.title, 'dox core');
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
