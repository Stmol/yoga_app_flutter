import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_yoga_fl/models/classroom_routine_model.dart';
import 'package:uuid/uuid.dart';

part 'classroom_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClassroomModel {
  static const DEFAULT_DURATION_BETWEEN_ASANAS = Duration(seconds: 10);

  @JsonKey(ignore: true)
  final String id;

  final String title;

  final String description;

  final String coverImage;

  // TODO: Convert to Duration from JSON int value?
  final int timeBetweenAsanas;

  final bool isPredefined;

  final List<ClassroomRoutineModel> classroomRoutines;

  // TODO: Memo
  Duration get durationBetweenAsanas => timeBetweenAsanas != null && timeBetweenAsanas >= 0
      ? Duration(seconds: timeBetweenAsanas)
      : Duration.zero;

  // TODO: Memo
  Duration get totalDuration => classroomRoutines.fold(durationBetweenAsanas, (prev, el) {
    return prev + (el.asanaDuration ?? Duration.zero);
  });

  ClassroomModel({
    String id,
    @required this.title,
    this.description,
    this.coverImage,
    List<ClassroomRoutineModel> classroomRoutines,
    this.timeBetweenAsanas = 300, // FIXME: Create from duration
    this.isPredefined = false,
  })  : assert(title != null),
        // TODO: assert(classroomRoutines.isNotEmpty)
        id = id ?? Uuid().v4(),
        classroomRoutines = classroomRoutines ?? [];

  factory ClassroomModel.fromJSON(Map<String, dynamic> json) => _$ClassroomModelFromJson(json);

  Map<String, dynamic> toJSON() => _$ClassroomModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassroomModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          coverImage == other.coverImage &&
          timeBetweenAsanas == other.timeBetweenAsanas &&
          isPredefined == other.isPredefined &&
          classroomRoutines == other.classroomRoutines;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      coverImage.hashCode ^
      timeBetweenAsanas.hashCode ^
      isPredefined.hashCode ^
      classroomRoutines.hashCode;
}
