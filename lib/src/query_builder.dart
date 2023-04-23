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
  late QueryBuilderHelper _helper;
  late Logger _logger;
  late PostgreSQLConnection _db;
  bool _debug = false;
  String _table = '';

  Map<String, dynamic> _substitutionValues = {};

  @override
  QueryBuilder get queryBuilder => this;

  @override
  PostgreSQLConnection get db => _db;

  @override
  QueryBuilderHelper get helper => _helper;

  @override
  Logger get logger => _logger;

  @override
  bool get shouldDebug => _debug;

  @override
  Map<String, dynamic> get substitutionValues => _substitutionValues;

  @override
  String get tableName => _table;

  @override
  String get rawQueryString => getRawQuery();

  @override
  String get selectQueryString => getSelectQuery();

  @override
  dynamic get modelType => null;

  @override
  addSubstitutionValues(String key, dynamic value) {
    return _substitutionValues[key] = value;
  }

  @override
  resetSubstitutionValues() {
    return _substitutionValues = {};
  }

  QueryBuilder() {
    SqlQueryBuilder instance = SqlQueryBuilder();
    _db = instance.db;
    _logger = Logger();
    _helper = QueryBuilderHelper(this);
    setDebug(instance.debug);
  }

  static QueryBuilder table(tableName) {
    return QueryBuilder().setTable(tableName);
  }

  QueryBuilder setDebug(bool debug) {
    _debug = debug;
    return this;
  }

  QueryBuilder setTable(tableName) {
    _table = tableName;
    return this;
  }
}
