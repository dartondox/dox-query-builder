import 'shared_mixin.dart';

mixin Insert implements SharedMixin {
  Future insert(Map<String, dynamic> data) async {
    List result = await insertMultiple([data]);
    if (result.isNotEmpty) {
      Map insertedData = result.first;
      int id = insertedData[tableName]['id'] ?? 0;
      return await queryBuilder.find(id);
    }
    return null;
  }

  Future insertMultiple(List<Map<String, dynamic>> list) async {
    List columns = [];
    List<String> values = [];
    Map<String, dynamic> substitutionValues = {};

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
        substitutionValues[columnKey] = value;
      });
      values.add("(${ret.join(',')})");
    }

    String query =
        "INSERT INTO $tableName (${columns.join(',')}) VALUES ${values.join(',')} RETURNING id;";

    if (shouldDebug) {
      logger.log(query, substitutionValues);
    }

    return await db.mappedResultsQuery(query,
        substitutionValues: substitutionValues);
  }
}
