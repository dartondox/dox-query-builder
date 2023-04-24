import 'query_builder.dart';
import 'shared_mixin.dart';

mixin OrderBy implements SharedMixin {
  final List<String> _orderBy = [];

  getOrderByQuery() {
    if (_orderBy.isNotEmpty) {
      return " ORDER BY ${_orderBy.join(',')}";
    }
    return "";
  }

  /// order by query
  ///
  /// ```
  /// List blogs = await Blog().orderBy('id').get()
  /// List blogs = await Blog().orderBy('id', 'desc').get()
  /// ```
  QueryBuilder orderBy(dynamic column, [dynamic type]) {
    _orderBy.add('$column ${type == null ? '' : type.toString()}');
    return queryBuilder;
  }
}
