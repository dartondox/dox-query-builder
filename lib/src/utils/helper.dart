import 'package:dox_query_builder/dox_query_builder.dart';

Type typeOf<T>() => T;

class QueryBuilderHelper<T> {
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

  Future<List> runQuery(query) async {
    Map<String, dynamic> values = queryBuilder.substitutionValues;
    if (queryBuilder.shouldDebug) queryBuilder.logger.log(query, values);
    var db = queryBuilder.db;
    query = query.replaceAll(RegExp(' +'), ' ');
    return await db.mappedResultsQuery(query, substitutionValues: values);
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
    if (queryBuilder.self != null &&
        queryBuilder.self.toString() != 'dynamic') {
      return result.map((e) {
        return queryBuilder.self.fromMap(e) as T;
      }).toList();
    }
    return result;
  }

  String pascalToSnake(String input) {
    final result = StringBuffer();
    for (final letter in input.codeUnits) {
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
}
