class HasOne {
  final Type model;
  final String? foreignKey;
  final String? localKey;
  final String? whereQuery;

  const HasOne(this.model, {this.foreignKey, this.localKey, this.whereQuery});
}

class HasMany {
  final Type model;
  final String? foreignKey;
  final String? localKey;
  final String? whereQuery;

  const HasMany(this.model, {this.foreignKey, this.localKey, this.whereQuery});
}

class BelongsTo {
  final Type model;
  final String? foreignKey;
  final String? ownerKey;
  final String? whereQuery;

  const BelongsTo(this.model,
      {this.foreignKey, this.ownerKey, this.whereQuery});
}
