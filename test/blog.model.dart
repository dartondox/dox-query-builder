import 'package:dox_query_builder/dox_query_builder.dart';

import 'blog_info.model.dart';

part 'blog.model.g.dart';

@DoxModel(primaryKey: 'uid')
class Blog extends BlogGenerator with SoftDeletes {
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

  Future<BlogInfo?> get blogInfo async {
    return await hasOne(() => BlogInfo()).end;
  }

  Future<List<BlogInfo>> get blogInfos async {
    return await hasMany(() => BlogInfo()).end;
  }
}
