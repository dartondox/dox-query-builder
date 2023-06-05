import 'query_builder.dart';
import 'shared_mixin.dart';

mixin SoftDeletes<T> implements SharedMixin<T> {
  @override
  bool isSoftDeletes = true;

  /// With trash (this function can be used with SoftDeletes only)
  ///
  /// ```
  /// List blogs = await Blog().withTrash().all();
  /// ```
  QueryBuilder<T> withTrash() {
    isSoftDeletes = false;
    return queryBuilder;
  }
}
