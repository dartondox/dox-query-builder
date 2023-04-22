import 'shared_mixin.dart';

mixin All implements SharedMixin {
  Future all<T>() async {
    String query = "SELECT $selectQueryString FROM $tableName";
    return helper.formatResult<T>(await helper.runQuery(query));
  }
}
