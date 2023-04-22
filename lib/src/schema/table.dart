import 'package:postgres/postgres.dart';

import '../utils/logger.dart';
import 'column.dart';

class Table {
  final List<Column> columns = [];
  String tableName = '';
  bool isDebug = false;

  late Logger _logger;
  late PostgreSQLConnection _db;

  Logger get logger => _logger;

  Table(PostgreSQLConnection db) {
    _db = db;
    _logger = Logger();
  }

  Table table(table) {
    tableName = table;
    return this;
  }

  Table debug(debug) {
    isDebug = debug;
    return this;
  }

  void id([dynamic column]) {
    columns.add(Column(name: column ?? 'id', type: "SERIAL PRIMARY KEY"));
  }

  Column uuid([dynamic column]) {
    Column col = Column(name: column ?? 'uuid', type: 'UUID');
    columns.add(col);
    return col;
  }

  Column integer(String name) {
    Column col = Column(name: name, type: 'INTEGER');
    columns.add(col);
    return col;
  }

  Column bigInteger(String name) {
    Column col = Column(name: name, type: 'BIGINT');
    columns.add(col);
    return col;
  }

  Column string(String name, [dynamic length]) {
    Column col = Column(name: name, type: "VARCHAR(${length ?? '100'})");
    columns.add(col);
    return col;
  }

  Column char(String name, [dynamic length]) {
    Column col = Column(name: name, type: "CHAR(${length ?? '8'})");
    columns.add(col);
    return col;
  }

  Column money(String name) {
    Column col = Column(name: name, type: "MONEY");
    columns.add(col);
    return col;
  }

  Column json(String name) {
    Column col = Column(name: name, type: "JSON");
    columns.add(col);
    return col;
  }

  Column jsonb(String name) {
    Column col = Column(name: name, type: "JSONB");
    columns.add(col);
    return col;
  }

  Column decimal(String name, [dynamic length, dynamic decimalPoint]) {
    Column col = Column(
        name: name, type: "DECIMAL(${length ?? '8'}, ${decimalPoint ?? '2'})");
    columns.add(col);
    return col;
  }

  Column float4(String name) {
    Column col = Column(name: name, type: "float4");
    columns.add(col);
    return col;
  }

  Column float8(String name) {
    Column col = Column(name: name, type: "float8");
    columns.add(col);
    return col;
  }

  Column text(String name) {
    Column col = Column(name: name, type: 'TEXT');
    columns.add(col);
    return col;
  }

  Column timestamp(String name) {
    Column col = Column(name: name, type: 'TIMESTAMP');
    columns.add(col);
    return col;
  }

  Column date(String name) {
    Column col = Column(name: name, type: 'DATE');
    columns.add(col);
    return col;
  }

  Column time(String name) {
    Column col = Column(name: name, type: 'TIME');
    columns.add(col);
    return col;
  }

  Column timestampTz(String name) {
    Column col = Column(name: name, type: 'TIMESTAMPTZ');
    columns.add(col);
    return col;
  }

  Column softDeletes([dynamic name]) {
    Column col =
        Column(name: name ?? 'deleted_at', type: 'TIMESTAMPTZ').nullable();
    columns.add(col);
    return col;
  }

  void timestamps() {
    Column createdAt =
        Column(name: 'created_at', type: 'TIMESTAMPTZ').nullable();
    Column updatedAt =
        Column(name: 'updated_at', type: 'TIMESTAMPTZ').nullable();
    columns.add(createdAt);
    columns.add(updatedAt);
  }

  Future<void> create() async {
    String query = "CREATE TABLE IF NOT EXISTS $tableName (";

    List ret = [];
    for (Column col in columns) {
      String defaultQuery = '';
      if (col.defaultValue != null) {
        defaultQuery = " DEFAULT '${col.defaultValue}'";
      }
      String unique = col.isUnique ? ' UNIQUE' : '';
      ret.add(
          "${col.name} ${col.type} ${col.isNullable ? 'NULL' : 'NOT NULL'}$defaultQuery$unique");
    }

    query += ret.join(',');
    query += ")";
    if (isDebug) {
      logger.log(query);
    }
    await _db.mappedResultsQuery(query);
  }
}
