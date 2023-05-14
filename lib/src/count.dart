import 'shared_mixin.dart';

mixin Count implements SharedMixin {
  /// Count record
  ///
  /// ```
  /// await Blog().count();
  /// ```
  count() async {
    String select = selectQueryString == '*'
        ? 'count(*) as total'
        : 'count(*) as total, $selectQueryString';
    String q = "SELECT $select FROM $tableName";
    q += helper.getCommonQuery();
    List result = await helper.formatResult(await helper.runQuery(q));
    return result.length == 1 ? result.first : result;
  }
}
