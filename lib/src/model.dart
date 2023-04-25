import '../sql_query_builder.dart';

class Model extends QueryBuilder {
  bool _debug = false;

  @override
  String get tableName => runtimeType.toString().toLowerCase();

  @override
  dynamic get modelType => this;

  QueryBuilder get newQuery =>
      QueryBuilder.table(tableName, this).debug(_debug);

  @override
  Model debug(bool debug) {
    _debug = debug;
    super.debug(debug);
    return this;
  }

  /// create new record in table
  ///
  /// ```
  /// Blog blog = new Blog();
  /// blog.title = 'blog title';
  /// await blog.save()
  /// ```
  Future save() async {
    Map<String, dynamic> values = helper.typeConverter.toMap(this);
    if (values[primaryKey] == null) {
      values.removeWhere((key, value) => value == null);
      values['created_at'] = now();
      values['updated_at'] = now();
      await QueryBuilder.table(tableName, modelType)
          .debug(_debug)
          .insert(values);
    } else {
      var id = values[primaryKey];
      values.remove(primaryKey);
      values.remove('created_at');
      values['updated_at'] = now();
      await QueryBuilder.table(tableName, modelType)
          .debug(_debug)
          .where('id', id)
          .update(values);
    }
  }

  toMap() {
    return helper.typeConverter.toMap(this);
  }
}
