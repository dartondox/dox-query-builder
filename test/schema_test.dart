import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:test/test.dart';

import 'connection.dart';

void main() async {
  SqlQueryBuilder.initialize(database: await connection(), debug: false);

  group('Schema |', () {
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
  });
}
