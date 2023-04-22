import 'shared_mixin.dart';

mixin Find implements SharedMixin {
  Future find<T>(dynamic arg1, [dynamic arg2]) async {
    String column = arg2 == null ? 'id' : arg1;
    String key = 'find_$column';
    dynamic value = arg2 ?? arg1;

    String query =
        "SELECT $selectQueryString FROM $tableName where $column =  @$key";
    addSubstitutionValues(key, value);

    List result = helper.formatResult<T>(await helper.runQuery(query));
    return result.isEmpty ? null : result.first;
  }
}
