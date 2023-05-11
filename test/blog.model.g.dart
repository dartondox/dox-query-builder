// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

class BlogGenerator extends Model {
  @override
  String get primaryKey => 'uid';

  @override
  String get tableName => 'blog';

  int? get uid => tempIdValue;

  set uid(val) => tempIdValue = val;

  Future<BlogInfo?> get blogInfo {
    return hasOne<BlogInfo>(this, () => BlogInfo());
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
      'title': instance.title,
      'status': instance.status,
      'body': instance.description,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
  }
}
