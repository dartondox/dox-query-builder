import 'package:dox_query_builder/dox_query_builder.dart';

import '../blog_info/blog_info.model.dart';

part 'blog.model.g.dart';

@DoxModel(
  primaryKey: 'uid',
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  softDelete: true,
)
class Blog extends BlogGenerator {
  @override
  List<String> get hidden => <String>['status'];

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
  List<BlogInfo> blogInfos = <BlogInfo>[];

  static String? slugTitle(Map<String, dynamic> map) {
    return map['title'];
  }

  static String? beforeGet(Map<String, dynamic> map) {
    return map['title'];
  }
}
