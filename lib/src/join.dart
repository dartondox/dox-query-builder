import 'query_builder.dart';
import 'shared_mixin.dart';

mixin Join implements SharedMixin {
  final List<String> _joins = [];

  String getJoinQuery() {
    if (_joins.isNotEmpty) {
      return " ${_joins.join(' ')}";
    }
    return '';
  }

  QueryBuilder leftJoin(String arg1, String arg2, String arg3, [dynamic arg4]) {
    return _query('LEFT JOIN', arg1, arg2, arg3, arg4);
  }

  QueryBuilder rightJoin(String arg1, String arg2, String arg3,
      [dynamic arg4]) {
    return _query('RIGHT JOIN', arg1, arg2, arg3, arg4);
  }

  QueryBuilder join(String arg1, String arg2, String arg3, [dynamic arg4]) {
    return _query('JOIN', arg1, arg2, arg3, arg4);
  }

  QueryBuilder joinRaw(rawQuery, [dynamic params]) {
    return _rawQuery('JOIN', rawQuery, params);
  }

  QueryBuilder leftJoinRaw(rawQuery, [dynamic params]) {
    return _rawQuery('LEFT JOIN', rawQuery, params);
  }

  QueryBuilder rightJoinRaw(rawQuery, [dynamic params]) {
    return _rawQuery('RIGHT JOIN', rawQuery, params);
  }

  QueryBuilder _query(String type, String arg1, String arg2, String arg3,
      [dynamic arg4]) {
    String condition = '=';
    String joinTable = arg1;
    String firstJoinColumn = arg2;
    String secondJoinColumn = arg3;
    if (arg4 != null) {
      condition = arg3;
      secondJoinColumn = arg4;
    }
    _joins.add(
        "$type $joinTable on $firstJoinColumn $condition $secondJoinColumn");
    return queryBuilder;
  }

  QueryBuilder _rawQuery(String type, rawQuery, [dynamic params]) {
    _joins.add('$type $rawQuery');
    if (params != null && params is Map) {
      params.forEach((key, value) {
        addSubstitutionValues(key, value);
      });
    }
    return queryBuilder;
  }
}