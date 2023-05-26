import '../dox_query_builder.dart';

class Model<T> extends QueryBuilder<T> {
  int? tempIdValue;
  DateTime? createdAt;
  DateTime? updatedAt;

  List<String> hidden = [];

  bool _debug = SqlQueryBuilder().debug;

  @override
  String get tableName => helper.pascalToSnake(runtimeType.toString());

  @override
  dynamic get self => this;

  Map<String, dynamic> get timestampsColumn => {
        'created_at': 'created_at',
        'updated_at': 'updated_at',
      };

  @override
  Model debug([debug]) {
    _debug = debug ?? true;
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
    String? createdAtColumn = timestampsColumn['created_at'];
    String? updatedAtColumn = timestampsColumn['updated_at'];

    Map<String, dynamic> values = toMap();
    if (values[primaryKey] == null) {
      values.removeWhere((key, value) => value == null);

      if (createdAtColumn != null) {
        values[createdAtColumn] = now();
        createdAt = values[createdAtColumn];
      }

      if (updatedAtColumn != null) {
        values[updatedAtColumn] = now();
        updatedAt = values[updatedAtColumn];
      }

      var res = await QueryBuilder.table(tableName)
          .setPrimaryKey(primaryKey)
          .debug(_debug)
          .insert(values);

      tempIdValue = res[primaryKey];
    } else {
      var id = values[primaryKey];
      values.remove(primaryKey);
      values.remove(createdAtColumn);

      if (updatedAtColumn != null) {
        values[updatedAtColumn] = now();
        updatedAt = values[updatedAtColumn];
      }

      await QueryBuilder.table(tableName, this)
          .setPrimaryKey(primaryKey)
          .debug(_debug)
          .where(primaryKey, id)
          .update(values);
    }
  }

  /// Reload eager relationship after new record created/updated.
  /// await Blog().reload()
  Future reload() async {
    await initPreload([this]);
  }

  // Model to json string converter
  ///
  /// ```
  /// Map<String, dynamic> blog = Blog().find(1).toJson();
  /// ```
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = toMap();
    for (String h in hidden) {
      data.remove(h);
    }
    return data;
  }

  Map<String, dynamic> toMap(
      {bool original = false, bool removeHiddenField = false}) {
    if (original == true) {
      return originalMap;
    }
    var data = convertToMap(this);
    if (removeHiddenField) {
      for (String h in hidden) {
        data.remove(h);
      }
    }
    return data;
  }

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
    return await _getRelation([this], name) as MODEL;
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
      return Function.apply(funcName, [
        [this]
      ]);
    }
    return null;
  }

  Future _getRelation(List i, name) async {
    if (relationsResultMatcher[name] != null) {
      Function funcName = relationsResultMatcher[name]!;
      return await Function.apply(funcName, [i]);
    }
  }

  @override
  Future<void> initPreload(List list) async {
    List pList = <dynamic>{...preloadList, ..._preloadList}.toList();
    for (String key in pList) {
      await _getRelation(list, key);
    }
  }

  /// end ********** preload
}
