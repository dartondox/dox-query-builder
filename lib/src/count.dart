import 'shared_mixin.dart';

mixin Count<T> implements SharedMixin<T> {
  /// count the record
  /// count() cannot use with select()
  /// ```
  /// await Blog().count();
  /// ```
  // ignore: always_specify_types
  Future<int> count() async {
    String q = "SELECT count(*) as total FROM $tableName";
    q += helper.getCommonQuery();
    List<dynamic> result = await helper.formatResult(await helper.runQuery(q),
        shouldMapWithModel: false);
    if (result.length == 1) {
      if (result.first['total'] != null) {
        return int.parse(result.first['total'].toString());
      }
    }
    return 0;
  }
}
