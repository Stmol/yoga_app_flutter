import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'classroom_model.g.dart';

@JsonSerializable()
class ClassroomModel {
  ClassroomModel({
    String id,
    @required this.title,
    this.description,
    this.coverImage,
    List<String> asanasUniqueNames,
    this.timeBetweenAsanas = 300,
    this.isPredefined = false,
  })  : id = id ?? Uuid().v4(),
        asanasUniqueNames = asanasUniqueNames ?? <String>[],
        assert(title != null);
  // FIXME: assert(asanasUniqueNames.isNotEmpty)

  final String id;
  final String title;
  final String description;
  final String coverImage;
  final int timeBetweenAsanas;
  final bool isPredefined;
  final List<String> asanasUniqueNames;

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
          asanasUniqueNames == other.asanasUniqueNames;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      coverImage.hashCode ^
      timeBetweenAsanas.hashCode ^
      isPredefined.hashCode ^
      asanasUniqueNames.hashCode;
}
