import 'query_builder.dart';
import 'shared_mixin.dart';

mixin Select implements SharedMixin {
  String _select = '*';

  String getSelectQuery() {
    return _select;
  }

  QueryBuilder select(dynamic selection) {
    if (selection is List<String>) {
      _select = selection.join(',');
    }
    if (selection is String) {
      _select = selection;
    }
    return queryBuilder;
  }
}
