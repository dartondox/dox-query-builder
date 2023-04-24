import 'package:sql_query_builder/sql_query_builder.dart';

import 'shared_mixin.dart';

mixin Delete implements SharedMixin {
  /// delete a record
  ///
  /// if SoftDeletes is used in model it will act as soft delete,
  /// otherwise it will delete completely from record
  ///
  /// ```
  /// await Blog().where('id', 1).delete();
  /// ```
  Future<void> delete() async {
    if (isSoftDeletes) {
      queryBuilder.update({'deleted_at': now()});
    } else {
      String q;
      q = "DELETE FROM $tableName";
      q += helper.getCommonQuery();
      await helper.runQuery(q);
    }
  }

  /// force delete a record
  ///
  /// if SoftDeletes is used in model and if you would like to delete
  /// completely from the record, use forceDelete()
  ///
  /// ```
  /// await Blog().where('id', 1).forceDelete();
  /// `
  Future<void> forceDelete() async {
    String q;
    q = "DELETE FROM $tableName";
    q += helper.getCommonQuery();
    await helper.runQuery(q);
  }
}
