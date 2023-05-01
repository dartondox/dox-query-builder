import 'package:json_annotation/json_annotation.dart';

class Column extends JsonKey {
  @override
  final String? name;

  // final Function(dynamic)? filter;
  const Column({this.name});
}

class IsModel extends JsonSerializable {
  @override
  final bool ignoreUnannotated;

  const IsModel({this.ignoreUnannotated = true});
}
