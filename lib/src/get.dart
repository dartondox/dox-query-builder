import 'shared_mixin.dart';

mixin Get implements SharedMixin {
  Future get<T>() async {
    String q;
    if (rawQueryString.isNotEmpty) {
      q = rawQueryString;
    } else {
      q = "SELECT $selectQueryString FROM $tableName";
      q += helper.getCommonQuery();
    }
    return helper.formatResult<T>(await helper.runQuery(q));
  }
}
