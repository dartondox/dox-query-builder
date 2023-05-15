// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

class BlogGenerator extends Model<Blog> {
  @override
  String get primaryKey => 'uid';

  @override
  Map<String, dynamic> get timestampsColumn => {
        'created_at': 'created_at',
        'updated_at': 'updated_at',
      };

  int? get uid => tempIdValue;

  set uid(val) => tempIdValue = val;

  Blog get newQuery => Blog();

  @override
  List get preloadList => [
        'blogInfo',
        'blogInfos',
      ];

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

  static Future getBlogInfo(List list) async {
    var result = await getHasOne<BlogInfo>(queryBlogInfo(list), list);
    for (Blog i in list) {
      i.blogInfo = result[i.tempIdValue.toString()];
      if (list.length == 1) {
        return i.blogInfo;
      }
    }
  }

  static BlogInfo? queryBlogInfo(List list) {
    return hasOne<BlogInfo>(
      list,
      () => BlogInfo(),
    );
  }

  static Future getBlogInfos(List list) async {
    var result = await getHasMany<BlogInfo>(queryBlogInfos(list), list);
    for (Blog i in list) {
      i.blogInfos = result[i.tempIdValue.toString()];
      if (list.length == 1) {
        return i.blogInfos;
      }
    }
  }

  static BlogInfo? queryBlogInfos(List list) {
    return hasMany<BlogInfo>(
      list,
      () => BlogInfo(),
    );
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
