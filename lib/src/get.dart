import 'shared_mixin.dart';

mixin Get implements SharedMixin {
  _buildQuery() {
    String q;
    if (rawQueryString.isNotEmpty) {
      q = rawQueryString;
    } else {
      q = "SELECT $selectQueryString FROM $tableName";
      q += helper.getCommonQuery();
    }
    q = q.replaceAll(RegExp(' +'), ' ');
    return q;
  }

  /// Get records
  ///
  /// ```
  /// List blogs = await Blog().where('status', 'active').get();
  /// ```
  Future get() async {
    return helper.formatResult(await helper.runQuery(_buildQuery()));
  }

  /// Get Sql string
  ///
  /// ```
  /// String query = Blog().where('status', 'active').toSql();
  /// ```
  String toSql() {
    String q = _buildQuery();
    Map<String, dynamic> values = queryBuilder.substitutionValues;
    String query = '';
    values.forEach((key, value) {
      query += q.replaceAll('@$key', value);
    });
    return query;
  }
}
