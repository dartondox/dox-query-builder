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

  static Future getBlog(List list) async {
    var result = await getBelongsTo<Blog>(queryBlog(list), list);
    for (BlogInfo i in list) {
      i.blog = result[i.tempIdValue.toString()];
      if (list.length == 1) {
        return i.blog;
      }
    }
  }

  static Blog? queryBlog(List list) {
    return belongsTo<Blog>(list, () => Blog());
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
