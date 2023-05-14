import 'package:dox_query_builder/dox_query_builder.dart';

T? belongsTo<T>(
  List list,
  Model Function() model, {
  String? foreignKey,
  String? ownerKey,
  dynamic onQuery,
}) {
  if (list.isEmpty) return null;

  Model foreign = list.first;
  Model owner = model().debug(foreign.shouldDebug);
  ownerKey = ownerKey ?? owner.primaryKey;
  foreignKey = foreignKey ?? "${owner.tableName}_id";

  List<String> ids = list.map((i) {
    var map = i.toMap();
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
        '${owner.tableName}.$ownerKey',
      )
      .whereIn('${foreign.tableName}.$foreignKey', ids);

  if (onQuery != null) {
    owner = onQuery(owner);
  }
  return owner as T;
}

getBelongsTo<T>(q, List list) async {
  if (q == null) return null;
  List results = await q.get();

  Map<String, dynamic> ret = {};

  /// filter matched values with local id value
  for (var r in results) {
    var map = r.toOriginalMap();
    ret[map['_foreign_id'].toString()] = r as T;
  }

  return ret;
}
