import 'query_builder.dart';
import 'shared_mixin.dart';

mixin Raw implements SharedMixin {
  String _rawQuery = '';

  String getRawQuery() {
    return _rawQuery;
  }

  /// Raw query (this function cannot used with Model)
  ///
  /// ```
  /// await QueryBuilder.rawQuery('select * from blog').get();
  /// ```
  QueryBuilder rawQuery(String query, [dynamic substitutionValues]) {
    _rawQuery = query;
    if (substitutionValues is Map<String, dynamic>) {
      substitutionValues.forEach((key, value) {
        addSubstitutionValues(key, value);
      });
    }
    return queryBuilder;
  }
}
