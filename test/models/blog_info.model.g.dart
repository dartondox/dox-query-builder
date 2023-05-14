// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_info.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

class BlogInfoGenerator extends Model<BlogInfo> {
  @override
  String get primaryKey => 'id';

  int? get id => tempIdValue;

  set id(val) => tempIdValue = val;

  @override
  Map<String, Function> get relationsResultMatcher => {
        'blog': getBlog,
      };

  @override
  Map<String, Function> get relationsQueryMatcher => {
        'blog': queryBlog,
      };

  static Future getBlog(BlogInfo i) async {
    var q = i.belongsTo(
      i,
      () => Blog(),
    );
    i.blog = isEmpty(i.blog) ? await q.end : i.blog;
    return i.blog;
  }

  static Blog queryBlog(BlogInfo i) {
    return i.belongsTo(
      i,
      () => Blog(),
    );
  }

  @override
  BlogInfo fromMap(Map<String, dynamic> m) => BlogInfo()
    ..id = m['id'] as int?
    ..info = m['info'] as Map<String, dynamic>?
    ..blogId = m['blog_id'] as int?;

  @override
  Map<String, dynamic> convertToMap(i) {
    BlogInfo instance = i as BlogInfo;
    return {
      'id': instance.id,
      'info': instance.info,
      'blog_id': instance.blogId,
    };
  }
}
