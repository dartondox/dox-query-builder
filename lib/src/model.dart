import 'dart:convert';

import '../dox_query_builder.dart';

class Model<T> extends QueryBuilder<T> {
  int? tempIdValue;

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
    }
  }

  Future reload() async {
    await initPreload(this);
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

  /// start ********** preload
  List get preloadList => [];
  final List _preloadList = [];

  Map<String, Function> relationsResultMatcher = {};
  Map<String, Function> relationsQueryMatcher = {};

  /// preload relationship
  /// ```
  /// Blog blog = await Blog().preload('comments').find(1);
  /// print(blog.comments);
  /// ```
  Model preload(String key) {
    _preloadList.add(key);
    return this;
  }

  /// Get relation result
  /// ```
  /// Blog blog = await Blog()find(1);
  /// await blog.$getRelation('comments');
  /// print(blog.comments);
  /// `
  Future<MODEL?> $getRelation<MODEL>(name) async {
    return await _getRelation(this, name) as MODEL;
  }

  /// Get relation query
  /// ```
  /// Blog blog = await Blog()find(1);
  /// Comment comment = blog.related<Comment>('comments');
  /// await comment.get();
  /// `
  MODEL? related<MODEL>(name) {
    if (relationsQueryMatcher[name] != null) {
      Function funcName = relationsQueryMatcher[name]!;
      return Function.apply(funcName, [this]);
    }
    return null;
  }

  Future _getRelation(i, name) async {
    if (relationsResultMatcher[name] != null) {
      Function funcName = relationsResultMatcher[name]!;
      return await Function.apply(funcName, [i]);
    }
  }

  @override
  Future<void> initPreload(i) async {
    List list = <dynamic>{...preloadList, ..._preloadList}.toList();
    for (String key in list) {
      await _getRelation(i, key);
    }
  }

  /// end ********** preload
}
