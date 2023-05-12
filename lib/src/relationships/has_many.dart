import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:dox_query_builder/src/shared_mixin.dart';

mixin HasMany implements SharedMixin {
  /// ```
  /// Future<List<BlogInfo>> get blogInfo {
  ///   return hasMany<BlogInfo>(() => BlogInfo());
  /// }
  /// ```
  QueryBuilder hasMany(
    Model Function() model, {
    String? foreignKey,
    String? localKey,
  }) {
    Model s = self as Model;
    Model m = model().debug(s.shouldDebug);
    String fKey = foreignKey ?? "${s.tableName}_id";
    String lKey = localKey ?? s.primaryKey;
    var mapData = s.toMap();
    return m.where(fKey, mapData[lKey]).setGetType('get');
  }
}
