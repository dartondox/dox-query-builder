import 'package:dox_query_builder/dox_query_builder.dart';

import 'shared_mixin.dart';

mixin Get implements SharedMixin {
  String _buildQuery() {
    String q = "SELECT $selectQueryString FROM $tableName";
    q += helper.getCommonQuery();
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
  Future find(dynamic arg1, [dynamic arg2]) async {
    String column = arg2 == null ? primaryKey : arg1;
    dynamic value = arg2 ?? arg1;
    return await queryBuilder.where(column, value).limit(1).getFirst();
  }

  /// Get records
  ///
  /// ```
  /// List blogs = await Blog().where('status', 'active').get();
  /// ```
  Future get() async {
    return await helper.formatResult(await helper.runQuery(_buildQuery()));
  }

  /// Get records
  ///
  /// ```
  /// Blog blogs = await Blog().where('status', 'active').getFirst();
  /// ```
  Future getFirst() async {
    queryBuilder.limit(1);
    List result =
        await helper.formatResult(await helper.runQuery(_buildQuery()));
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

  /// Direct raw query to database
  ///
  /// ```
  /// var result = await QueryBuilder.query('select * from blog where id =  @id', {'id' : 1});
  ///
  Future query(query, {Map<String, dynamic>? substitutionValues = const {}}) {
    return SqlQueryBuilder().db.query(
          query,
          substitutionValues: substitutionValues,
        );
  }
}
