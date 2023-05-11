import 'shared_mixin.dart';

mixin Insert implements SharedMixin {
  /// create/insert a record
  ///
  /// ```
  /// Blog blog = await Blog().create({
  ///   "title" : "Blog title",
  ///   "body" : "Lorem",
  /// });
  /// ```
  Future create(Map<String, dynamic> data) async {
    await insert(data);
  }

  /// insert/create a record
  ///
  /// ```
  /// Blog blog = await Blog().insert({
  ///   "title" : "Blog title",
  ///   "body" : "Lorem",
  /// });
  /// ```
  Future insert(Map<String, dynamic> data) async {
    List result = await insertMultiple([data]);
    if (result.isNotEmpty) {
      Map insertedData = result.first;
      int id = insertedData[tableName][primaryKey] ?? 0;
      resetSubstitutionValues();
      return await queryBuilder.find(id);
    }
    return null;
  }

  /// insert/create multiple records
  ///
  /// ```
  /// Blog blog = await Blog().insert([
  ///   {"title" : "Blog title"},
  ///   {"title" : "Another blog title"},
  /// ]);
  /// ```
  Future insertMultiple(List<Map<String, dynamic>> list) async {
    List columns = [];
    List<String> values = [];

    // creating columns (col1, col2);
    list.first.forEach((key, value) {
      columns.add(key);
    });

    // creating values to insert (value1, val2);
    for (var data in list) {
      List ret = [];
      data.forEach((key, value) {
        String columnKey = helper.parseColumnKey(key);
        ret.add("@$columnKey");
        addSubstitutionValues(columnKey, value);
      });
      values.add("(${ret.join(',')})");
    }

    String query =
        "INSERT INTO $tableName (${columns.join(',')}) VALUES ${values.join(',')} RETURNING $primaryKey";
    return await helper.runQuery(query);
  }
}
