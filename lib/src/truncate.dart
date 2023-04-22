import 'shared_mixin.dart';

mixin Truncate implements SharedMixin {
  Future<void> truncate({bool resetId = true}) async {
    String reset = resetId ? 'RESTART IDENTITY CASCADE' : '';
    String query = "TRUNCATE TABLE $tableName $reset";
    await helper.runQuery(query);
  }
}
