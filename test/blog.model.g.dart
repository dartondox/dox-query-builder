// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) => Blog()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..status = json['status'] as String?
  ..description = json['body'] as String?
  ..deletedAt = json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String)
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..updatedAt = json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String);

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'body': instance.description,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
