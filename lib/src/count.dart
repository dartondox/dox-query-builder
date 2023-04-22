import 'shared_mixin.dart';

mixin Count implements SharedMixin {
  count() async {
    String select = selectQueryString == '*'
        ? 'count(*) as total'
        : 'count(*) as total, $selectQueryString';
    String q = "SELECT $select FROM $tableName";
    q += helper.getCommonQuery();
    List result = helper.formatResult(await helper.runQuery(q));
    return result.length == 1 ? result.first : result;
  }
}
