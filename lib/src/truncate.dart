import 'shared_mixin.dart';

mixin Truncate implements SharedMixin {
  /// Truncate table
  ///
  /// ```
  /// await Blog().truncate();
  /// await Blog().truncate(resetId: true);
  /// ```
  Future<void> truncate({bool resetId = true}) async {
    String reset = resetId ? 'RESTART IDENTITY CASCADE' : '';
    String query = "TRUNCATE TABLE $tableName $reset";
    await helper.runQuery(query);
  }
}
