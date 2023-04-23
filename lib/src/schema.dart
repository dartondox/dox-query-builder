import '/sql_query_builder.dart';

class Schema {
  static Future create(tableName, callback) async {
    SqlQueryBuilder instance = SqlQueryBuilder();
    Table table = Table(instance.db).table(tableName).debug(instance.debug);
    callback(table);
    await table.create();
  }

  static Future<void> drop(tableName) async {
    SqlQueryBuilder instance = SqlQueryBuilder();
    instance.db.query("DROP TABLE IF EXISTS $tableName RESTRICT");
  }
}
