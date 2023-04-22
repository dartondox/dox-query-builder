import 'shared_mixin.dart';

mixin Delete implements SharedMixin {
  Future<void> delete() async {
    String q;
    q = "DELETE FROM $tableName";
    q += helper.getCommonQuery();
    await helper.runQuery(q);
  }
}
