// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asana_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AsanaModel _$AsanaModelFromJson(Map<String, dynamic> json) {
  return AsanaModel(
    uniqueName: json['uniqueName'] as String,
    imageUrl: json['imageUrl'] as String,
    title: json['title'] as String,
    level: (json['level'] as num)?.toDouble(),
    description: json['description'] as String,
    warnings: json['warnings'] as String,
  );
}

Map<String, dynamic> _$AsanaModelToJson(AsanaModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'uniqueName': instance.uniqueName,
      'imageUrl': instance.imageUrl,
      'level': instance.level,
      'description': instance.description,
      'warnings': instance.warnings,
    };
