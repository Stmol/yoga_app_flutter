import 'package:json_annotation/json_annotation.dart';

part 'asana_model.g.dart';

@JsonSerializable()
class AsanaModel {
  final String title;
  final String uniqueName;
  final String imageUrl;
  final double level;
  final String description;
  final String warnings;

  AsanaModel(
      {this.uniqueName, this.imageUrl, this.title, this.level, this.description, this.warnings});

  factory AsanaModel.fromJson(Map<String, dynamic> json) => _$AsanaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AsanaModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsanaModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          uniqueName == other.uniqueName &&
          imageUrl == other.imageUrl &&
          level == other.level &&
          description == other.description &&
          warnings == other.warnings;

  @override
  int get hashCode =>
      title.hashCode ^
      uniqueName.hashCode ^
      imageUrl.hashCode ^
      level.hashCode ^
      description.hashCode ^
      warnings.hashCode;
}
