import 'shared_mixin.dart';

mixin All<T> implements SharedMixin<T> {
  /// Get all record from table
  ///
  /// ```
  /// await Blog().all();
  /// ```
  // ignore: always_specify_types
  Future all() async {
    String query = "SELECT $selectQueryString FROM $tableName";
    if (isSoftDeletes) {
      query += ' WHERE deleted_at IS NULL';
    }
    return helper.formatResult(await helper.runQuery(query));
  }
}
