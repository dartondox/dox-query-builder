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

class Builder {
  final PostgreSQLConnection db;
  bool _debug = false;

  Builder(this.db);

  Builder debug(bool debug) {
    _debug = debug;
    return this;
  }

  QueryBuilder table(tableName) {
    return QueryBuilder(db).setDebug(_debug).setTable(tableName);
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
  addSubstitutionValues(String key, dynamic value) {
    return _substitutionValues[key] = value;
  }

  @override
  resetSubstitutionValues() {
    return _substitutionValues = {};
  }

  QueryBuilder(PostgreSQLConnection db) {
    _db = db;
    _logger = Logger();
    _helper = QueryBuilderHelper(this);
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
