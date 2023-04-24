import 'shared_mixin.dart';

mixin Update implements SharedMixin {
  /// where raw condition
  ///
  /// ```
  /// Blog blog = await Blog().where('id', 1).update({
  ///   "title" : "new title",
  /// });
  /// ```
  Future<void> update(Map<String, dynamic> data) async {
    String q;
    q = "UPDATE $tableName SET ";

    List<String> columnToUpdate = [];
    data.forEach((column, value) {
      String key = helper.parseColumnKey(column);
      columnToUpdate.add("$column = @$key");
      addSubstitutionValues(key, value);
    });
    q += columnToUpdate.join(',');
    q += helper.getCommonQuery();
    await helper.runQuery(q);
  }
}
