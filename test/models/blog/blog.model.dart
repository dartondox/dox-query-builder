import 'package:dox_query_builder/dox_query_builder.dart';

import '../blog_info/blog_info.model.dart';

part 'blog.model.g.dart';

@DoxModel(primaryKey: 'uid', createdAt: 'created_at', updatedAt: 'updated_at')
class Blog extends BlogGenerator with SoftDeletes {
  @Column(beforeSave: slugTitle, beforeGet: beforeGet)
  String? title;

  @Column()
  String? status;

  @Column(name: 'body')
  String? description;

  @Column(name: 'deleted_at')
  DateTime? deletedAt;

  @HasOne(BlogInfo, eager: true)
  BlogInfo? blogInfo;

  @HasMany(BlogInfo, eager: true)
  List<BlogInfo> blogInfos = [];

  static slugTitle(Map<String, dynamic> map) {
    return map['title'];
  }

  static beforeGet(Map<String, dynamic> map) {
    return map['title'];
  }
}
