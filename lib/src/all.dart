import 'shared_mixin.dart';

mixin All implements SharedMixin {
  Future<List> all() async {
    String query = "SELECT $selectQueryString FROM $tableName";
    return helper.formatResult(await helper.runQuery(query));
  }
}
