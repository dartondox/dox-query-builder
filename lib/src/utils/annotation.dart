class DoxModel {
  final String? table;
  final String? primaryKey;

  const DoxModel({this.table, this.primaryKey});
}

class Column {
  final String? name;
  final Function? beforeSave;
  final Function? beforeGet;

  const Column({
    this.name,
    this.beforeSave,
    this.beforeGet,
  });
}

abstract class Relation {}

class HasOne implements Relation {
  final dynamic model;
  final String? foreignKey;
  final String? localKey;

  const HasOne(this.model, {this.foreignKey, this.localKey});
}
