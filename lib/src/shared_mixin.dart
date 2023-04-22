import 'package:postgres/postgres.dart';
import 'package:sql_query_builder/sql_query_builder.dart';

import 'utils/helper.dart';
import 'utils/logger.dart';

abstract class SharedMixin {
  QueryBuilder get queryBuilder;
  QueryBuilderHelper get helper;
  Logger get logger;
  PostgreSQLConnection get db;
  bool get shouldDebug;
  Map<String, dynamic> get substitutionValues;
  String get tableName;
  String get rawQueryString;
  String get selectQueryString;

  addSubstitutionValues(String key, dynamic value) {}
  resetSubstitutionValues() {}
}
