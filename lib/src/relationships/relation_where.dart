class WhereBuilder {
  String parseColumnKey(column) {
    var timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    return "$column$timestamp".replaceAll(RegExp(r'[^\w]'), "");
  }

  final List<String> _wheres = [];
  final Map<String, dynamic> _substitutionValues = {};

  List<String> getWheres() {
    return _wheres;
  }

  Map<String, dynamic> getParams() {
    return _substitutionValues;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    print(invocation.memberName);
  }

  /// where condition
  ///
  /// ```
  /// List blogs = await where('id', 1);
  /// ```
  WhereBuilder where(String arg1, [dynamic arg2, dynamic arg3]) {
    return _query('AND', arg1, arg2, arg3);
  }

  /// or where condition
  ///
  /// ```
  /// List blogs = await orWhere('id', 1);
  /// ```
  WhereBuilder orWhere(String arg1, [dynamic arg2, dynamic arg3]) {
    return _query('OR', arg1, arg2, arg3);
  }

  /// where raw condition
  ///
  /// ```
  /// List blogs = await whereRaw('id = @id', {"id" : 1});
  /// ```
  WhereBuilder whereRaw(rawQuery, [dynamic params]) {
    return _rawQuery('AND', rawQuery, params);
  }

  /// where raw condition
  ///
  /// ```
  /// List blogs = await orWhereRaw('id = @id', {"id" : 1});
  /// ```
  WhereBuilder orWhereRaw(rawQuery, [dynamic params]) {
    return _rawQuery('OR', rawQuery, params);
  }

  WhereBuilder _query(String type, dynamic arg1, [dynamic arg2, dynamic arg3]) {
    String column = arg1.toString();
    String condition = '=';
    String value = arg2.toString();
    if (arg3 != null) {
      condition = arg2;
      value = arg3.toString();
    }
    String columnKey = parseColumnKey(column);
    _wheres.add("$type $column $condition @$columnKey");
    _substitutionValues[columnKey] = value;
    return this;
  }

  WhereBuilder _rawQuery(String type, rawQuery, [dynamic params]) {
    if (_wheres.isEmpty) {
      _wheres.add(rawQuery);
    } else {
      _wheres.add("$type $rawQuery");
    }
    if (params is Map) {
      params.forEach((key, value) {
        _substitutionValues[key] = value;
      });
    }
    return this;
  }
}
