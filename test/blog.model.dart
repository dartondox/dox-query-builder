import 'package:dox_query_builder/dox_query_builder.dart';

import 'blog_info.model.dart';

part 'blog.model.g.dart';

@DoxModel(primaryKey: 'uid', table: 'blog')
class Blog extends BlogGenerator with SoftDeletes {
  @Column()
  String? title;

  static const Map<String, Relation> relations = {
    'blogInfo': HasOne(BlogInfo),
  };

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
}
