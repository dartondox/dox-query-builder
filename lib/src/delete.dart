import 'package:sql_query_builder/sql_query_builder.dart';

import 'shared_mixin.dart';

mixin Delete implements SharedMixin {
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

  Future<void> forceDelete() async {
    String q;
    q = "DELETE FROM $tableName";
    q += helper.getCommonQuery();
    await helper.runQuery(q);
  }
}
