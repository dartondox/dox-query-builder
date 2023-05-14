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

class HasOne {
  final Type model;
  final String? foreignKey;
  final String? localKey;
  final Function? onQuery;

  const HasOne(this.model, {this.foreignKey, this.localKey, this.onQuery});
}

class HasMany {
  final Type model;
  final String? foreignKey;
  final String? localKey;
  final Function? onQuery;

  const HasMany(this.model, {this.foreignKey, this.localKey, this.onQuery});
}

class BelongsTo {
  final Type model;
  final String? foreignKey;
  final String? ownerKey;
  final Function? onQuery;

  const BelongsTo(this.model, {this.foreignKey, this.ownerKey, this.onQuery});
}
