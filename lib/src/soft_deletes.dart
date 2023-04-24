import 'query_builder.dart';
import 'shared_mixin.dart';

mixin SoftDeletes implements SharedMixin {
  @override
  bool isSoftDeletes = true;

  QueryBuilder withTrash() {
    isSoftDeletes = false;
    return queryBuilder;
  }
}
