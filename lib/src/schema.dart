import '/sql_query_builder.dart';

class Schema {
  /// create table with schema
  ///
  /// ```
  /// await Schema.create('table', (Table table) {
  ///   table.id();
  ///   table.string('title').nullable();
  ///   table.char('status').withDefault('active');
  ///   table.text('body');
  ///   table.softDeletes();
  ///   table.timestamps();
  /// });
  /// ```
  static Future<void> create(tableName, callback) async {
    Table table = Table().table(tableName);
    callback(table);
    await table.create();
  }

  /// update table with schema
  ///
  /// ```
  /// await Schema.table('table', (Table table) {
  ///   table.id();
  ///   table.string('title').nullable();
  ///   table.char('status').withDefault('active');
  ///   table.text('body');
  ///   table.softDeletes();
  ///   table.timestamps();
  /// });
  /// ```
  static Future<void> table(tableName, callback) async {
    Table table = Table().table(tableName);
    callback(table);
    await table.update();
  }

  /// drop table
  ///
  /// ```
  /// await Schema.drop('table');
  /// ```
  static Future<void> drop(tableName) async {
    SqlQueryBuilder().db.query("DROP TABLE IF EXISTS $tableName RESTRICT");
  }
}
