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

  Future get() async {
    return helper.formatResult(await helper.runQuery(_buildQuery()));
  }

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
