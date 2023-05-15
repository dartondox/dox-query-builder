import 'package:dox_query_builder/dox_query_builder.dart';

T? hasOne<T>(
  List list,
  Model Function() model, {
  String? foreignKey,
  String? localKey,
  dynamic onQuery,
}) {
  if (list.isEmpty) return null;

  Model owner = list.first;
  localKey = localKey ?? owner.primaryKey;
  foreignKey = foreignKey ?? "${owner.tableName}_id";

  List<String> ids = list.map((i) {
    var map = i.toMap();
    return map[localKey].toString();
  }).toList();

  Model m = model().debug(owner.shouldDebug);

  m.select('*, $foreignKey as _owner_id').whereIn(foreignKey, ids);

  if (onQuery != null) {
    m = onQuery(m);
  }
  return m as T;
}

getHasOne<T>(q, List list) async {
  if (q == null) return null;
  List results = await q.get();

  Map<String, T> ret = {};

  /// filter matched values with local id value
  for (var r in results) {
    r = r as Model;
    var map = r.toMap(original: true);
    String ownerId = map['_owner_id'].toString();
    ret[ownerId] = r as T;
  }

  return ret;
}
