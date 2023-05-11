import 'package:dox_query_builder/dox_query_builder.dart';

Future<T?> hasOne<T>(
  Model self,
  Model Function() model, {
  String? foreignKey,
  String? localKey,
}) async {
  Model m = model();
  await m.leftJoin(m.tableName, "${m.tableName}.id", '').limit(1).get();

  return m as T;
}
