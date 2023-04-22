import 'query_builder.dart';
import 'shared_mixin.dart';

mixin Limit implements SharedMixin {
  String _limit = '';
  String _offset = '0';

  String getLimitQuery() {
    if (_limit.isNotEmpty) {
      return " LIMIT $_limit OFFSET $_offset";
    }
    return "";
  }

  QueryBuilder take(int value) {
    _limit = value.toString();
    return queryBuilder;
  }

  QueryBuilder limit(int value) {
    _limit = value.toString();
    return queryBuilder;
  }

  QueryBuilder offset(int value) {
    _offset = value.toString();
    return queryBuilder;
  }
}
