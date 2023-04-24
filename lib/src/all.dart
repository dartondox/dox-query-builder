import 'shared_mixin.dart';

mixin All implements SharedMixin {
  /// Get all record from table
  ///
  /// ```
  /// await Blog().all();
  /// ```
  Future all() async {
    String query = "SELECT $selectQueryString FROM $tableName";
    if (isSoftDeletes) {
      query += ' WHERE deleted_at IS NULL';
    }
    return helper.formatResult(await helper.runQuery(query));
  }
}
