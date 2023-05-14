// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

class BlogGenerator extends Model<Blog> {
  @override
  String get primaryKey => 'uid';

  int? get uid => tempIdValue;

  set uid(val) => tempIdValue = val;

  @override
  Map<String, Function> get relationsResultMatcher => {
        'blogInfo': getBlogInfo,
        'blogInfos': getBlogInfos,
      };

  @override
  Map<String, Function> get relationsQueryMatcher => {
        'blogInfo': queryBlogInfo,
        'blogInfos': queryBlogInfos,
      };

  static Future getBlogInfo(Blog i) async {
    var q = queryBlogInfo(i);
    i.blogInfo = isEmpty(i.blogInfo) ? await q.end : i.blogInfo;
    return i.blogInfo;
  }

  static BlogInfo queryBlogInfo(Blog i) {
    var q = i.hasOne(
      i,
      () => BlogInfo(),
    );
    q = Blog.blogInfoQuery(q);
    return q;
  }

  static Future getBlogInfos(Blog i) async {
    var q = queryBlogInfos(i);
    i.blogInfos = isEmpty(i.blogInfos) ? await q.end : i.blogInfos;
    return i.blogInfos;
  }

  static BlogInfo queryBlogInfos(Blog i) {
    var q = i.hasMany(
      i,
      () => BlogInfo(),
    );

    return q;
  }

  @override
  Blog fromMap(Map<String, dynamic> m) => Blog()
    ..uid = m['uid'] as int?
    ..title = m['title'] as String?
    ..status = m['status'] as String?
    ..description = m['body'] as String?
    ..deletedAt = m['deleted_at'] == null
        ? null
        : DateTime.parse(m['deleted_at'] as String)
    ..createdAt = m['created_at'] == null
        ? null
        : DateTime.parse(m['created_at'] as String)
    ..updatedAt = m['updated_at'] == null
        ? null
        : DateTime.parse(m['updated_at'] as String);

  @override
  Map<String, dynamic> convertToMap(i) {
    Blog instance = i as Blog;
    return {
      'uid': instance.uid,
      'title': Blog.slugTitle(instance.title),
      'status': instance.status,
      'body': instance.description,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
  }
}
