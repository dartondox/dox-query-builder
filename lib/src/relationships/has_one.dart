import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:dox_query_builder/src/shared_mixin.dart';

mixin HasOneQuery implements SharedMixin {
  hasOne(
    Model i,
    Model Function() model, {
    String? foreignKey,
    String? localKey,
  }) {
    Model m = model().debug(i.shouldDebug);
    String fKey = foreignKey ?? "${i.tableName}_id";
    String lKey = localKey ?? i.primaryKey;
    var mapData = i.toMap();
    return m.where(fKey, mapData[lKey]).setGetType('getFirst');
  }
}
