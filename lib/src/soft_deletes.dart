import 'package:sql_query_builder/sql_query_builder.dart';

import 'shared_mixin.dart';

mixin SoftDeletes implements SharedMixin {
  @override
  bool isSoftDeletes = true;

  QueryBuilder withTrash() {
    isSoftDeletes = false;
    return queryBuilder;
  }
}
