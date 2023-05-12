import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:dox_query_builder/src/shared_mixin.dart';

mixin BelongsTo implements SharedMixin {
  /// ```
  /// Future<Blog> get blog {
  ///   return belongsTo<blog>(() => Blog());
  /// }
  /// ```
  QueryBuilder belongsTo(
    Model Function() model, {
    String? foreignKey,
    String? ownerKey,
  }) {
    Model s = self as Model;
    Model m = model().debug(s.shouldDebug);
    String fKey = foreignKey ?? "${m.tableName}_id";
    String oKey = ownerKey ?? m.primaryKey;
    var mapData = s.toMap();
    return m.where(oKey, mapData[fKey]).setGetType('getFirst');
  }
}
