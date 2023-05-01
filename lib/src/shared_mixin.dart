import 'package:postgres/postgres.dart';

import 'query_builder.dart';
import 'utils/helper.dart';
import 'utils/logger.dart';

abstract class SharedMixin {
  QueryBuilder get queryBuilder;
  QueryBuilderHelper get helper;
  Logger get logger;
  PostgreSQLConnection get db;
  Map<String, dynamic> get substitutionValues;
  String get rawQueryString;
  String get selectQueryString;
  String get primaryKey;
  bool shouldDebug = false;
  dynamic modelType;
  String tableName = '';
  bool isSoftDeletes = false;
  toMap();
  fromJson(Map<String, dynamic> json);

  addSubstitutionValues(String key, dynamic value) {}
  resetSubstitutionValues() {}
}
