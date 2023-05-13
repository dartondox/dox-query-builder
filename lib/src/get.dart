import 'package:dox_query_builder/dox_query_builder.dart';

import 'shared_mixin.dart';

mixin Get implements SharedMixin {
  String _getType = 'get';

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

  /// Find a record
  ///
  /// ```
  /// await Blog().find(1);
  /// await Blog().find('name', 'John');
  /// ```
  /// If only [arg1] is provided, it will as as id value,
  /// If both [arg1] and [arg2] ar provided, [arg1] is column name and
  /// [arg2] is value of column
  /// This cannot be use with other query such as, where, join, delete.
  Future find(dynamic arg1, [dynamic arg2]) {
    String column = arg2 == null ? primaryKey : arg1;
    dynamic value = arg2 ?? arg1;
    return queryBuilder.where(column, value).limit(1).getFirst();
  }

  /// Get records
  ///
  /// ```
  /// List blogs = await Blog().where('status', 'active').get();
  /// ```
  Future get() async {
    return helper.formatResult(await helper.runQuery(_buildQuery()));
  }

  /// Get records
  ///
  /// ```
  /// Blog blogs = await Blog().where('status', 'active').getFirst();
  /// ```
  Future getFirst() async {
    queryBuilder.limit(1);
    List result = helper.formatResult(await helper.runQuery(_buildQuery()));
    return result.isEmpty ? null : result.first;
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

  // Get records
  ///
  /// ```
  /// List blogs = await Blog().where('status', 'active').end;
  /// ```
  Future get end async {
    if (_getType == 'get') {
      return get();
    }
    if (_getType == 'getFirst') {
      return getFirst();
    }
  }

  QueryBuilder setGetType(type) {
    _getType = type;
    return queryBuilder;
  }
}
