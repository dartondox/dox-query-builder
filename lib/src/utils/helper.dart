import 'dart:mirrors';

import '../query_builder.dart';
import 'json_key.dart';

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
    if (queryBuilder.shouldDebug) queryBuilder.logger.log(query, values);
    var db = queryBuilder.db;
    if (db.isClosed) {
      await db.open();
    }
    if (mapped) {
      return await db.mappedResultsQuery(query, substitutionValues: values);
    } else {
      return await db.query(query, substitutionValues: values);
    }
  }

  List formatResult<T>(List queryResult) {
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
    if (T.toString() != 'dynamic') {
      return result.map((e) => convertToType<T>(e)).toList();
    }
    return result;
  }

  T convertToType<T>(Map data) {
    List<dynamic> positionalParams = [];
    Map<Symbol, dynamic> namedParams = {};

    ClassMirror classMirror = reflectClass(T);
    // get main class
    MethodMirror constructorMirror = classMirror.declarations.values
        .whereType<MethodMirror>()
        .firstWhere((m) => m.isConstructor);

    // get dependency class list
    List<ParameterMirror> parameters = constructorMirror.parameters.toList();

    for (ParameterMirror param in parameters) {
      String column = MirrorSystem.getName(param.simpleName);
      if (param.isNamed) {
        // if param is with name
        namedParams[param.simpleName] = data[column];
      } else {
        // if param is positional
        positionalParams.add(data[column]);
      }
    }

    // create class
    var mirror = classMirror.newInstance(
      Symbol.empty,
      positionalParams,
      namedParams,
    );

    // override value with JsonKey
    Map<Symbol, DeclarationMirror> nameFieldMirrors = mirror.type.declarations;
    nameFieldMirrors.forEach((key, value) {
      for (var m in value.metadata) {
        bool isJsonKey = m.type.reflectedType == JsonKey;
        if (isJsonKey) {
          JsonKey jsonKey = m.reflectee;
          var newValue = data[jsonKey.name];
          if (jsonKey.filter != null) {
            newValue = jsonKey.filter!(newValue);
          }
          mirror.setField(key, newValue);
        }
      }
    });

    // return class with values
    return mirror.reflectee;
  }
}
