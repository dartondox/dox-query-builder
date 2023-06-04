import 'package:dox_query_builder/dox_query_builder.dart';

T? manyToMany<T>(
  List list,
  Model Function() model, {
  dynamic onQuery,
  String? localKey,
  String? relatedKey,
  String? pivotForeignKey,
  String? pivotRelatedForeignKey,
  String? pivotTable,
}) {
  if (list.isEmpty) return null;

  Model local = list.first;
  Model related = model();

  localKey = localKey ?? local.primaryKey;
  relatedKey = relatedKey ?? related.primaryKey;

  String localTable = local.tableName;
  String relatedTable = related.tableName;

  // @todo: sort by alphabet to join table;
  pivotTable = pivotTable ?? _sortTableByAlphabet(relatedTable, localTable);

  pivotForeignKey = pivotForeignKey ?? '${localTable}_id';
  pivotRelatedForeignKey = pivotRelatedForeignKey ?? '${relatedTable}_id';

  List<String> ids = list.map((i) {
    var map = i.toMap();
    return map[localKey].toString();
  }).toList();

  var q = related
      .debug(local.shouldDebug)
      .select('$relatedTable.*, $pivotTable.$pivotForeignKey as _owner_id')
      .leftJoin(pivotTable, '$pivotTable.$pivotRelatedForeignKey',
          '$relatedTable.$relatedKey')
      .whereIn('$pivotTable.$pivotForeignKey', ids);

  if (onQuery != null) {
    q = onQuery(q);
  }
  return q as T;
}

String _sortTableByAlphabet(String firstTable, String secondTable) {
  List<String> tables = [firstTable, secondTable];
  tables.sort();
  return '${tables[0]}_${tables[1]}';
}

Future getManyToMany<T>(q, List list) async {
  if (q == null) return [];
  List results = await q.get();

  Map<String, List<T>> ret = {};

  /// filter matched values with local id value
  for (var r in results) {
    r = r as Model;
    var map = r.toMap(original: true);
    String ownerId = map['_owner_id'].toString();
    if (ret[ownerId] == null) {
      ret[ownerId] = [];
    }
    ret[ownerId]?.add(r as T);
  }

  /// to prevent result null instead return empty list
  for (var i in list) {
    ret[i.tempIdValue.toString()] = ret[i.tempIdValue.toString()] ?? [];
  }

  return ret;
}
