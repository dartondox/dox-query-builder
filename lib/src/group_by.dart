import 'query_builder.dart';
import 'shared_mixin.dart';

mixin GroupBy implements SharedMixin {
  String _groupBy = '';

  String getGroupByQuery() {
    return _groupBy;
  }

  QueryBuilder groupBy(dynamic column) {
    if (column is String) {
      _groupBy = ' GROUP BY $column';
    }
    if (column is List) {
      _groupBy = ' GROUP BY ${column.join(',')}';
    }
    return queryBuilder;
  }
}
