import 'shared_mixin.dart';

mixin Find implements SharedMixin {
  /// Find a record
  ///
  /// ```
  /// await Blog().find(1);
  /// await Blog().find('name', 'John');
  /// ```
  /// If only [arg1] is provided, it will as as id value,
  /// If both [arg1] and [arg2] ar provided, [arg1] is column name and
  /// [arg2] is value of column
  /// This cannot be use with other query such as, where, join, delete.
  Future find(dynamic arg1, [dynamic arg2]) async {
    String column = arg2 == null ? 'id' : arg1;
    String key = 'find_$column';
    dynamic value = arg2 ?? arg1;

    String query =
        "SELECT $selectQueryString FROM $tableName where $column =  @$key";
    if (isSoftDeletes) {
      query += ' AND deleted_at IS NULL';
    }
    addSubstitutionValues(key, value);

    List result = helper.formatResult(await helper.runQuery(query));
    return result.isEmpty ? null : result.first;
  }
}
