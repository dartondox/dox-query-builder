import 'package:dox_query_builder/dox_query_builder.dart';

class QueryBuilderHelper<T> {
  final QueryBuilder<T> queryBuilder;
  QueryBuilderHelper(this.queryBuilder);

  String parseColumnKey(String column) {
    String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    return "$column$timestamp".replaceAll(RegExp(r'[^\w]'), "");
  }

  String getCommonQuery() {
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

  Future<List<Map<String, Map<String, dynamic>>>> runQuery(String query) async {
    Map<String, dynamic> values = queryBuilder.substitutionValues;
    if (queryBuilder.shouldDebug) queryBuilder.logger.log(query, values);
    DBDriver db = queryBuilder.db;
    query = query.replaceAll(RegExp(' +'), ' ');
    return await db.mappedResultsQuery(query, substitutionValues: values);
  }

  // ignore: always_specify_types
  Future<List> formatResult(
      List<Map<String, Map<String, dynamic>>> queryResult) async {
    List<Map<String, dynamic>> result = <Map<String, dynamic>>[];
    // setting key values format from query result
    for (Map<String, Map<String, dynamic>> row in queryResult) {
      Map<String, dynamic> ret = <String, dynamic>{};
      (row).forEach((String mainKey, Map<String, dynamic> data) {
        (data).forEach((String key, dynamic value) {
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

    if (queryBuilder.self != null &&
        queryBuilder.self.toString() != 'dynamic') {
      List<T> ret = <T>[];
      for (Map<String, dynamic> e in result) {
        dynamic res = queryBuilder.self.fromMap(e);
        res.originalMap = e;
        ret.add(res as T);
      }
      await queryBuilder.initPreload(ret as List<Model<T>>);
      return ret;
    }
    return result;
  }

  String pascalToSnake(String input) {
    StringBuffer result = StringBuffer();
    for (int letter in input.codeUnits) {
      if (letter >= 65 && letter <= 90) {
        // Check if uppercase ASCII
        if (result.isNotEmpty) {
          // Add underscore if not first letter
          result.write('_');
        }
        result.write(String.fromCharCode(letter + 32)); // Add lowercase ASCII
      } else {
        result.write(String.fromCharCode(letter)); // Add original character
      }
    }
    String finalString = result.toString().replaceAll(RegExp('_+'), '_');
    return finalString;
  }

  String lcFirst(String? str) {
    if (str == null) {
      return '';
    }
    return str.substring(0, 1).toLowerCase() + str.substring(1);
  }
}
