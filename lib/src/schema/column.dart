class Column {
  final String name;
  final String? type;

  bool isNullable = false;
  dynamic defaultValue;
  bool isUnique = false;

  Column({
    required this.name,
    this.type,
  });

  Column nullable([dynamic nullable]) {
    isNullable = (nullable is bool) ? nullable : true;
    return this;
  }

  Column withDefault(dynamic val) {
    defaultValue = val;
    return this;
  }

  Column unique() {
    isUnique = true;
    return this;
  }
}
