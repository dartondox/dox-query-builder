import 'shared_mixin.dart';

mixin Find implements SharedMixin {
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
