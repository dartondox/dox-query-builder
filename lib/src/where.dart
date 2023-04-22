import 'query_builder.dart';
import 'shared_mixin.dart';

mixin Where implements SharedMixin {
  final List<String> _wheres = [];

  String getWhereQuery() {
    if (_wheres.isNotEmpty) {
      return " WHERE ${_wheres.join(' ')}";
    }
    return '';
  }

  QueryBuilder where(String arg1, [dynamic arg2, dynamic arg3]) {
    return _query('AND', arg1, arg2, arg3);
  }

  QueryBuilder orWhere(String arg1, [dynamic arg2, dynamic arg3]) {
    return _query('OR', arg1, arg2, arg3);
  }

  QueryBuilder whereRaw(rawQuery, [dynamic params]) {
    return _rawQuery('AND', rawQuery, params);
  }

  QueryBuilder orWhereRaw(rawQuery, [dynamic params]) {
    return _rawQuery('OR', rawQuery, params);
  }

  QueryBuilder _query(String type, dynamic arg1, [dynamic arg2, dynamic arg3]) {
    String column = arg1.toString();
    String condition = '=';
    String value = arg2.toString();
    if (arg3 != null) {
      condition = arg2;
      value = arg3.toString();
    }
    String columnKey = helper.parseColumnKey('$column$value');
    if (_wheres.isEmpty) {
      _wheres.add("$column $condition @$columnKey");
    } else {
      _wheres.add("$type $column $condition @$columnKey");
    }
    addSubstitutionValues(columnKey, value);
    return queryBuilder;
  }

  QueryBuilder _rawQuery(String type, rawQuery, [dynamic params]) {
    if (_wheres.isEmpty) {
      _wheres.add(rawQuery);
    } else {
      _wheres.add("$type $rawQuery");
    }
    if (params is Map) {
      params.forEach((key, value) {
        addSubstitutionValues(key, value);
      });
    }
    return queryBuilder;
  }
}
