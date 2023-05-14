import 'package:dox_query_builder/dox_query_builder.dart';

import 'all.dart';
import 'count.dart';
import 'delete.dart';
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

  DBDriver db = PostgresDriver();

  bool debug = true;

  static initialize({required dynamic database, bool? debug}) {
    SqlQueryBuilder sql = SqlQueryBuilder();
    sql.db = PostgresDriver(conn: database);
    sql.debug = debug ?? false;
  }
}

class QueryBuilder<T>
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
        Truncate,
        Delete,
        Count {
  Map<String, dynamic> _substitutionValues = {};

  @override
  QueryBuilder get queryBuilder => this;

  @override
  String primaryKey = 'id';

  /// PostgresSQL database
  /// ```
  /// QueryBuilder.db.query("select * from blog");
  /// ```
  @override
  DBDriver get db => SqlQueryBuilder().db;

  @override
  QueryBuilderHelper get helper => QueryBuilderHelper<T>(this);

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
  dynamic self;

  @override
  bool isSoftDeletes = false;

  /// table to query
  @override
  String tableName = '';

  @override
  List<String> hidden = [];

  @override
  Map<String, dynamic> originalMap = {};

  Map<String, dynamic> convertToMap(i) {
    return {};
  }

  @override
  Future<void> initPreload(List list) async {}

  @override
  fromMap(Map<String, dynamic> json) {}

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
    builder.self = type;
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

  /// set debug on or of
  ///
  /// ```
  /// QueryBuilder.table('blog').setPrimaryKey('uid')
  /// ```
  QueryBuilder setPrimaryKey(String id) {
    primaryKey = id;
    return this;
  }
}
