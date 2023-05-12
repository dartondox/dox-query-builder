import 'dart:convert';

import '../dox_query_builder.dart';

class Model<T> extends QueryBuilder<T> {
  bool _debug = SqlQueryBuilder().debug;

  @override
  String get tableName => helper.pascalToSnake(runtimeType.toString());

  @override
  dynamic get self => this;

  QueryBuilder get newQuery => QueryBuilder.table(tableName, this)
      .debug(_debug)
      .setPrimaryKey(primaryKey);

  @override
  Model debug(bool debug) {
    _debug = debug;
    super.debug(debug);
    return this;
  }

  int? tempIdValue;

  /// create new record in table
  ///
  /// ```
  /// Blog blog = new Blog();
  /// blog.title = 'blog title';
  /// await blog.save()
  /// ```
  Future save() async {
    Map<String, dynamic> values = toMap();
    if (values[primaryKey] == null) {
      values.removeWhere((key, value) => value == null);
      values['created_at'] = now();
      values['updated_at'] = now();
      var res = await QueryBuilder.table(tableName)
          .setPrimaryKey(primaryKey)
          .debug(_debug)
          .insert(values);
      tempIdValue = res[primaryKey];
      return fromMap(res);
    } else {
      var id = values[primaryKey];
      values.remove(primaryKey);
      values.remove('created_at');
      values['updated_at'] = now();
      await QueryBuilder.table(tableName, this)
          .setPrimaryKey(primaryKey)
          .debug(_debug)
          .where(primaryKey, id)
          .update(values);
      return this;
    }
  }

  // Model to json string converter
  ///
  /// ```
  /// String blog = Blog().find(1).toJson();
  /// ```
  String toJson() {
    Map<String, dynamic> data = toMap();
    for (String h in hidden) {
      data.remove(h);
    }
    return jsonEncode(data);
  }

  Map<String, dynamic> toMap() => convertToMap(this);
}
