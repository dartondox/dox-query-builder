import 'package:json_annotation/json_annotation.dart';

class Column extends JsonKey {
  const Column({name}) : super(name: name);
}

class IsModel extends JsonSerializable {
  const IsModel() : super(ignoreUnannotated: true);
}
