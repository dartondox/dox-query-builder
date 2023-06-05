import 'shared_mixin.dart';

mixin Count<T> implements SharedMixin<T> {
  /// Count record
  ///
  /// ```
  /// await Blog().count();
  /// ```
  // ignore: always_specify_types
  Future count() async {
    String select = selectQueryString == '*'
        ? 'count(*) as total'
        : 'count(*) as total, $selectQueryString';
    String q = "SELECT $select FROM $tableName";
    q += helper.getCommonQuery();
    List<dynamic> result = await helper.formatResult(await helper.runQuery(q));
    return result.length == 1 ? result.first : result;
  }
}
