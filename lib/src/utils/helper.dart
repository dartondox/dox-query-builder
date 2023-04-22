import '../query_builder.dart';

class QueryBuilderHelper {
  final QueryBuilder queryBuilder;
  QueryBuilderHelper(this.queryBuilder);

  String parseColumnKey(column) {
    var timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    return "$column$timestamp".replaceAll(RegExp(r'[^\w]'), "");
  }

  getCommonQuery() {
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
    if (queryBuilder.shouldDebug) {
      queryBuilder.logger.log(query, values);
    }
    var db = queryBuilder.db;
    if (mapped) {
      return await db.mappedResultsQuery(query, substitutionValues: values);
    } else {
      return await db.query(query, substitutionValues: values);
    }
  }

  List formatResult(List queryResult) {
    List result = [];
    for (final row in queryResult) {
      Map ret = {};
      (row as Map).forEach((mainKey, data) {
        (data as Map).forEach((key, value) {
          if (ret[key] == null) {
            ret[key] = value;
          } else {
            ret["${mainKey}_$key"] = value;
          }
        });
      });
      result.add(ret);
    }
    return result;
  }
}
