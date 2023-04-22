import 'package:postgres/postgres.dart';

import 'schema/table.dart';

class Schema {
  late PostgreSQLConnection _db;
  late bool _isDebug = false;

  Schema(PostgreSQLConnection db) {
    _db = db;
  }

  debug(debug) {
    _isDebug = debug;
    return this;
  }

  Future create(tableName, callback) async {
    Table table = Table(_db).table(tableName).debug(_isDebug);
    callback(table);
    await table.create();
  }

  Future<void> drop(tableName) async {
    _db.query("DROP TABLE IF EXISTS $tableName RESTRICT");
  }
}
