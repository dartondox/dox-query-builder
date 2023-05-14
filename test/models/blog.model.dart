import 'package:dox_query_builder/dox_query_builder.dart';

import 'blog_info.model.dart';

part 'blog.model.g.dart';

@DoxModel(primaryKey: 'uid')
class Blog extends BlogGenerator with SoftDeletes {
  @override
  List get preloadList => ['blogInfo'];

  @Column()
  String? title;

  @Column()
  String? status;

  @Column(name: 'body')
  String? description = 'something';

  @Column(name: 'deleted_at')
  DateTime? deletedAt;

  @Column(name: 'created_at')
  DateTime? createdAt;

  @Column(name: 'updated_at')
  DateTime? updatedAt = now();

  @HasOne(BlogInfo)
  BlogInfo? blogInfo;

  @HasMany(BlogInfo)
  List<BlogInfo> blogInfos = [];
}
