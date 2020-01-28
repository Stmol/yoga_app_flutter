// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_routine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassroomRoutineModel _$ClassroomRoutineModelFromJson(
    Map<String, dynamic> json) {
  return ClassroomRoutineModel(
    asanaUniqueName: json['asanaUniqueName'] as String,
    asanaDuration: ClassroomRoutineModel._asanaDurationFromSeconds(
        json['asanaDuration'] as int),
  );
}

Map<String, dynamic> _$ClassroomRoutineModelToJson(
        ClassroomRoutineModel instance) =>
    <String, dynamic>{
      'asanaUniqueName': instance.asanaUniqueName,
      'asanaDuration':
          ClassroomRoutineModel._asanaDurationToSeconds(instance.asanaDuration),
    };
