import 'package:sql_query_builder/sql_query_builder.dart';

part 'blog.model.g.dart';

@IsModel()
class Blog extends Model with SoftDeletes {
  @Column()
  int? id;

  @Column()
  String? title;

  @Column()
  String? status;

  @Column(name: 'body')
  String? description;

  @Column(name: 'deleted_at')
  DateTime? deletedAt;

  @Column(name: 'created_at')
  DateTime? createdAt;

  @Column(name: 'updated_at')
  DateTime? updatedAt;

  @override
  fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  @override
  toMap() => _$BlogToJson(this);
}
