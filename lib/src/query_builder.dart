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

  dynamic self;

  @override
  QueryBuilder get queryBuilder => this;

  @override
  String primaryKey = 'id';

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
  String get selectQueryString => getSelectQuery();

  @override
  bool isSoftDeletes = false;

  @override
  String tableName = '';

  @override
  dynamic addSubstitutionValues(String key, dynamic value) {
    return _substitutionValues[key] = value;
  }

  @override
  Map<String, dynamic> resetSubstitutionValues() {
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
  QueryBuilder debug([debug]) {
    shouldDebug = debug ?? true;
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

  /// **** map

  Map<String, dynamic> originalMap = {};

  Map<String, dynamic> convertToMap(i) {
    return {};
  }

  Future<void> initPreload(List<Model<T>> list) async {}

  dynamic fromMap(Map<String, dynamic> m) {}

  /// **** map
}
