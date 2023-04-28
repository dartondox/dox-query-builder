import 'package:postgres/postgres.dart';

import '../utils/logger.dart';
import 'table.column.dart';

abstract class TableSharedMixin {
  final List<TableColumn> columns = [];
  String tableName = '';
  bool debug = false;
  PostgreSQLConnection get db;
  Logger get logger;
}
