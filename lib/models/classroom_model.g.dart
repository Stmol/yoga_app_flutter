// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomModel _$ClassroomModelFromJson(Map<String, dynamic> json) {
  return ClassroomModel(
    title: json['title'] as String,
    description: json['description'] as String,
    coverImage: json['coverImage'] as String,
    classroomRoutines: (json['classroomRoutines'] as List)
        ?.map((e) => e == null
            ? null
            : ClassroomRoutineModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    timeBetweenAsanas: json['timeBetweenAsanas'] as int,
    isPredefined: json['isPredefined'] as bool,
  );
}

Map<String, dynamic> _$ClassroomModelToJson(ClassroomModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'coverImage': instance.coverImage,
      'timeBetweenAsanas': instance.timeBetweenAsanas,
      'isPredefined': instance.isPredefined,
      'classroomRoutines':
          instance.classroomRoutines?.map((e) => e?.toJson())?.toList(),
    };
