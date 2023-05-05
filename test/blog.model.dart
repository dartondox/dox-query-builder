import 'package:dox_query_builder/dox_query_builder.dart';

part 'blog.model.g.dart';

@IsModel()
class Blog extends Model with SoftDeletes {
  @JsonKey()
  int? id;

  @JsonKey()
  String? title;

  @JsonKey()
  String? status;

  @JsonKey(name: 'body')
  String? description;

  @JsonKey(name: 'deleted_at')
  DateTime? deletedAt;

  @JsonKey(name: 'created_at')
  DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  @override
  fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  @override
  toMap() => _$BlogToJson(this);
}
