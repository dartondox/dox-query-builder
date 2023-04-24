import '/sql_query_builder.dart';

class Schema {
  static Future create(tableName, callback) async {
    Table table = Table().table(tableName);
    callback(table);
    await table.create();
  }

  static Future<void> drop(tableName) async {
    SqlQueryBuilder().db.query("DROP TABLE IF EXISTS $tableName RESTRICT");
  }
}
