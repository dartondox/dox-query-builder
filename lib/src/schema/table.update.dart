import 'table.column.dart';
import 'table.shared_mixin.dart';

mixin TableUpdate implements TableSharedMixin {
  Future<void> update() async {
    for (TableColumn col in columns) {
      if (col.shouldDrop == true) {
        _handleDrop(col);
      } else if (col.renameTo != null) {
        _handleRename(col);
      } else {
        List existingColumns = await getTableColumns();
        if (!existingColumns.contains(col.name)) {
          _handleAdd(col);
        } else {
          _handleAlter(col);
        }
      }
    }
  }

  _handleDrop(TableColumn col) async {
    String query = 'ALTER TABLE $tableName DROP COLUMN ${col.name}';
    return await _runQuery(query);
  }

  _handleRename(TableColumn col) async {
    String query =
        'ALTER TABLE $tableName RENAME COLUMN ${col.name} TO ${col.renameTo}';
    return await _runQuery(query);
  }

  _handleAdd(TableColumn col) async {
    String defaultQuery =
        col.defaultValue != null ? " DEFAULT '${col.defaultValue}'" : '';
    String unique = col.isUnique ? ' UNIQUE' : '';
    String query =
        "ALTER TABLE $tableName ADD COLUMN ${col.name} ${col.type} ${col.isNullable ? 'NULL' : 'NOT NULL'}$defaultQuery$unique";
    return await _runQuery(query);
  }

  _handleAlter(TableColumn col) async {
    List queries = [];

    /// changing type
    if (col.type != null) {
      queries.add("ALTER COLUMN ${col.name} TYPE ${col.type}");
    }

    /// changing default value
    if (col.defaultValue != null) {
      queries.add("ALTER COLUMN ${col.name} SET DEFAULT '${col.defaultValue}'");
    }

    /// set null
    queries.add(
        "ALTER COLUMN ${col.name} ${col.isNullable ? 'DROP NOT NULL' : 'SET NOT NULL'}");

    /// set unique
    if (col.isUnique) {
      queries.add("ADD CONSTRAINT unique_${col.name} UNIQUE (${col.name})");
    }

    /// run final query
    String query = "ALTER TABLE $tableName ${queries.join(',')}";
    return await _runQuery(query);
  }

  _runQuery(query) async {
    if (debug) {
      logger.log(query);
    }
    await db.mappedResultsQuery(query);
  }

  Future getTableColumns() async {
    String query =
        "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$tableName'";
    List<Map<String, Map<String, dynamic>>> result =
        await db.mappedResultsQuery(query);

    List columns = [];
    for (Map<dynamic, Map> element in result) {
      element.forEach((key, value) {
        value.forEach((key2, value2) {
          columns.add(value2);
        });
      });
    }
    return columns;
  }
}
