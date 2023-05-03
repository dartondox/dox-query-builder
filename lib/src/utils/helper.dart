import 'package:dox_query_builder/dox_query_builder.dart';

class QueryBuilderHelper {
  final QueryBuilder queryBuilder;
  QueryBuilderHelper(this.queryBuilder);

  String parseColumnKey(column) {
    var timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    return "$column$timestamp".replaceAll(RegExp(r'[^\w]'), "");
  }

  getCommonQuery() {
    if (queryBuilder.isSoftDeletes) {
      queryBuilder.whereRaw('deleted_at IS NULL');
    }
    String query = "";
    query += queryBuilder.getJoinQuery();
    query += queryBuilder.getWhereQuery();
    query += queryBuilder.getOrderByQuery();
    query += queryBuilder.getGroupByQuery();
    query += queryBuilder.getLimitQuery();
    return query;
  }

  Future<List> runQuery(query, {bool mapped = true}) async {
    Map<String, dynamic> values = queryBuilder.substitutionValues;
    if (queryBuilder.shouldDebug) queryBuilder.logger.log(query, values);
    var db = queryBuilder.db;
    if (db.isClosed) {
      await db.open();
    }
    query = query.replaceAll(RegExp(' +'), ' ');
    if (mapped) {
      return await db.mappedResultsQuery(query, substitutionValues: values);
    } else {
      return await db.query(query, substitutionValues: values);
    }
  }

  List formatResult(List queryResult) {
    List<Map<String, dynamic>> result = [];
    for (final row in queryResult) {
      Map<String, dynamic> ret = {};
      (row as Map<String, dynamic>).forEach((mainKey, data) {
        (data as Map<String, dynamic>).forEach((key, value) {
          if (ret[key] == null) {
            ret[key] = value is DateTime ? value.toIso8601String() : value;
          } else {
            ret["${mainKey}_$key"] =
                value is DateTime ? value.toIso8601String() : value;
          }
        });
      });
      result.add(ret);
    }
    if (queryBuilder.modelType != null &&
        queryBuilder.modelType.toString() != 'dynamic') {
      return result.map((e) {
        return queryBuilder.modelType.fromJson(e);
      }).toList();
    }
    return result;
  }
}
