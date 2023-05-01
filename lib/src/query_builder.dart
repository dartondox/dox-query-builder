import 'package:postgres/postgres.dart';

import 'all.dart';
import 'count.dart';
import 'delete.dart';
import 'find.dart';
import 'get.dart';
import 'group_by.dart';
import 'insert.dart';
import 'join.dart';
import 'limit.dart';
import 'order_by.dart';
import 'raw.dart';
import 'select.dart';
import 'truncate.dart';
import 'update.dart';
import 'utils/helper.dart';
import 'utils/logger.dart';
import 'where.dart';

class SqlQueryBuilder {
  static final SqlQueryBuilder _singleton = SqlQueryBuilder._internal();

  factory SqlQueryBuilder() {
    return _singleton;
  }

  SqlQueryBuilder._internal();

  late PostgreSQLConnection db;
  late bool debug;

  static initialize({required PostgreSQLConnection database, bool? debug}) {
    SqlQueryBuilder sql = SqlQueryBuilder();
    sql.db = database;
    sql.debug = debug ?? false;
  }
}

class QueryBuilder
    with
        Limit,
        Where,
        OrderBy,
        GroupBy,
        Insert,
        Join,
        Raw,
        Get,
        Update,
        Select,
        All,
        Find,
        Truncate,
        Delete,
        Count {
  Map<String, dynamic> _substitutionValues = {};

  @override
  QueryBuilder get queryBuilder => this;

  @override
  String get primaryKey => 'id';

  /// PostgresSQL database
  /// ```
  /// QueryBuilder.db.query("select * from blog");
  /// ```
  @override
  PostgreSQLConnection get db => SqlQueryBuilder().db;

  @override
  QueryBuilderHelper get helper => QueryBuilderHelper(this);

  @override
  Logger get logger => Logger();

  @override
  bool shouldDebug = SqlQueryBuilder().debug;

  @override
  Map<String, dynamic> get substitutionValues => _substitutionValues;

  @override
  String get rawQueryString => getRawQuery();

  @override
  String get selectQueryString => getSelectQuery();

  @override
  dynamic modelType;

  @override
  bool isSoftDeletes = false;

  /// table to query
  @override
  String tableName = '';

  @override
  toMap() {
    return {};
  }

  @override
  fromJson(Map<String, dynamic> json) {}

  @override
  addSubstitutionValues(String key, dynamic value) {
    return _substitutionValues[key] = value;
  }

  @override
  resetSubstitutionValues() {
    return _substitutionValues = {};
  }

  /// set table and continue query
  ///
  /// ```
  /// QueryBuilder.table('blog');
  /// ```
  /// set table name [tableName] as first parameter
  /// and model instance [type] in second parameter [type] is optional
  /// this return QueryBuilder
  static QueryBuilder table(tableName, [dynamic type]) {
    QueryBuilder builder = QueryBuilder();
    builder.tableName = tableName;
    builder.modelType = type;
    return builder;
  }

  /// set debug on or of
  ///
  /// ```
  /// QueryBuilder.table('blog').debug(true)
  /// ```
  QueryBuilder debug(bool debug) {
    shouldDebug = debug;
    return this;
  }
}
