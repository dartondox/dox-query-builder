import 'query_builder.dart';
import 'utils/type_converter.dart';

class Model extends QueryBuilder {
  @override
  String get tableName => runtimeType.toString().toLowerCase();

  @override
  dynamic get modelType => this;

  String get primaryKey => 'id';

  TypeConverter get typeConverter => TypeConverter();

  Future save() async {
    Map<String, dynamic> values = typeConverter.toMap(this);
    if (values[primaryKey] == null) {
      values.removeWhere((key, value) => value == null);
      await setTable(tableName).insert(values);
    } else {
      var id = values[primaryKey];
      values.remove(primaryKey);
      await setTable(tableName).where('id', id).update(values);
    }
  }
}
