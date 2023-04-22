import 'shared_mixin.dart';

mixin Insert implements SharedMixin {
  insert(List<Map<String, dynamic>> list) {
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
        String columnKey = helper.parseColumnKey('$key$value');
        ret.add("@$columnKey");
        substitutionValues[columnKey] = value;
      });
      values.add("(${ret.join(',')})");
    }

    String query =
        "INSERT INTO $tableName (${columns.join(',')}) VALUES ${values.join(',')}";

    if (shouldDebug) {
      logger.log(query, substitutionValues);
    }

    return db.query(query, substitutionValues: substitutionValues);
  }
}
