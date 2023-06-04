// ignore_for_file: always_specify_types

import 'package:dox_query_builder/dox_query_builder.dart';

T? belongsTo<T>(
  List list,
  Model Function() model, {
  String? foreignKey,
  String? localKey,
  dynamic onQuery,
}) {
  if (list.isEmpty) return null;

  Model foreign = list.first;
  Model owner = model().debug(foreign.shouldDebug);
  localKey = localKey ?? owner.primaryKey;
  foreignKey = foreignKey ?? "${owner.tableName}_id";

  List<String> ids = list.map((i) {
    Map<String, dynamic> map = i.toMap();
    return map[foreignKey].toString();
  }).toList();

  owner
      .select([
        '${owner.tableName}.*',
        '${foreign.tableName}.${foreign.primaryKey} as _foreign_id'
      ])
      .leftJoin(
        foreign.tableName,
        '${foreign.tableName}.$foreignKey',
        '${owner.tableName}.$localKey',
      )
      .whereIn('${foreign.tableName}.$foreignKey', ids);

  if (onQuery != null) {
    owner = onQuery(owner);
  }
  return owner as T;
}

Future<Map<String, T>> getBelongsTo<T>(dynamic q, List list) async {
  if (q == null) return <String, T>{};
  List results = await q.get();

  Map<String, T> ret = <String, T>{};

  /// filter matched values with local id value
  for (var r in results) {
    r = r as Model;
    Map<String, dynamic> map = r.toMap(original: true);
    ret[map['_foreign_id'].toString()] = r as T;
  }

  return ret;
}
