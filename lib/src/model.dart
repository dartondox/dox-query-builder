import '../sql_query_builder.dart';
import 'utils/type_converter.dart';

class Model extends QueryBuilder {
  @override
  String get tableName => runtimeType.toString().toLowerCase();

  @override
  dynamic get modelType => this;

  String get primaryKey => 'id';

  TypeConverter get typeConverter => TypeConverter();

  QueryBuilder get newQuery => QueryBuilder.table(tableName, this);

  Future save() async {
    Map<String, dynamic> values = typeConverter.toMap(this);
    if (values[primaryKey] == null) {
      values.removeWhere((key, value) => value == null);
      values['created_at'] = now();
      values['updated_at'] = now();
      await QueryBuilder.table(tableName, this).insert(values);
    } else {
      var id = values[primaryKey];
      values.remove(primaryKey);
      values.remove('created_at');
      values['updated_at'] = now();
      await QueryBuilder.table(tableName, this).where('id', id).update(values);
    }
  }
}
