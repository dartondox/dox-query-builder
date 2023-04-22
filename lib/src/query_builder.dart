import 'package:postgres/postgres.dart';

import 'all.dart';
import 'count.dart';
import 'find.dart';
import 'get.dart';
import 'group_by.dart';
import 'insert.dart';
import 'join.dart';
import 'limit.dart';
import 'order_by.dart';
import 'raw.dart';
import 'select.dart';
import 'utils/helper.dart';
import 'utils/logger.dart';
import 'where.dart';

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
        Select,
        All,
        Find,
        Count {
  late QueryBuilderHelper _helper;
  late Logger _logger;
  late PostgreSQLConnection _db;
  bool _debug = false;
  String _table = '';
  final Map<String, dynamic> _substitutionValues = {};

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
  addSubstitutionValues(String key, dynamic value) {
    return _substitutionValues[key] = value;
  }

  QueryBuilder(PostgreSQLConnection db) {
    if (db.isClosed) {
      db.open();
    }
    _db = db;
    _logger = Logger();
    _helper = QueryBuilderHelper(this);
  }

  QueryBuilder debug(bool debug) {
    _debug = debug;
    return this;
  }

  QueryBuilder table(tableName) {
    _table = tableName;
    return this;
  }
}
