import 'query_builder.dart';
import 'shared_mixin.dart';

mixin SoftDeletes implements SharedMixin {
  @override
  bool isSoftDeletes = true;

  /// With trash (this function can be used with SoftDeletes only)
  ///
  /// ```
  /// List blogs = await Blog().withTrash().all();
  /// ```
  QueryBuilder withTrash() {
    isSoftDeletes = false;
    return queryBuilder;
  }
}
