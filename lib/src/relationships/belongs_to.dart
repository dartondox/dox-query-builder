import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:dox_query_builder/src/shared_mixin.dart';

mixin BelongsToQuery implements SharedMixin {
  belongsTo(
    Model i,
    Model Function() model, {
    String? foreignKey,
    String? ownerKey,
  }) {
    Model m = model().debug(i.shouldDebug);
    String fKey = foreignKey ?? "${m.tableName}_id";
    String oKey = ownerKey ?? m.primaryKey;
    var mapData = i.toMap();
    return m.where(oKey, mapData[fKey]).setGetType('getFirst');
  }
}
