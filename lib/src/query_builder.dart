import 'package:dox_query_builder/dox_query_builder.dart';

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
        Limit<T>,
        Where<T>,
        OrderBy<T>,
        GroupBy<T>,
        Insert<T>,
        Join<T>,
        Raw<T>,
        Get<T>,
        Update<T>,
        Select<T>,
        Truncate<T>,
        Delete<T>,
        Count<T> {
  Map<String, dynamic> _substitutionValues = <String, dynamic>{};

  dynamic self;

  @override
  QueryBuilder<T> get queryBuilder => this;

  @override
  String primaryKey = 'id';

  @override
  DBDriver get db => SqlQueryBuilder().db;

  @override
  QueryBuilderHelper<T> get helper => QueryBuilderHelper<T>(this);

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
    return _substitutionValues = <String, dynamic>{};
  }

  /// set table and continue query
  ///
  /// ```
  /// QueryBuilder.table('blog');
  /// ```
  /// set table name [tableName] as first parameter
  /// and model instance [type] in second parameter [type] is optional
  /// this return QueryBuilder
  static QueryBuilder<T> table<T>(String tableName, [dynamic type]) {
    QueryBuilder<T> builder = QueryBuilder<T>();
    builder.tableName = tableName;
    builder.self = type;
    return builder;
  }

  /// set debug on or of
  ///
  /// ```
  /// QueryBuilder.table('blog').debug(true)
  /// ```
  QueryBuilder<T> debug([bool? debug]) {
    shouldDebug = debug ?? true;
    return this;
  }

  /// set debug on or of
  ///
  /// ```
  /// QueryBuilder.table('blog').setPrimaryKey('uid')
  /// ```
  QueryBuilder<T> setPrimaryKey(String id) {
    primaryKey = id;
    return this;
  }

  /// **** map

  Map<String, dynamic> originalMap = <String, dynamic>{};

  Map<String, dynamic> convertToMap(dynamic i) {
    return <String, dynamic>{};
  }

  Future<void> initPreload(List<Model<T>> list) async {}

  dynamic fromMap(Map<String, dynamic> m) {}

  /// **** map
}
