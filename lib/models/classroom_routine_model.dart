import 'package:json_annotation/json_annotation.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:uuid/uuid.dart';

part 'classroom_routine_model.g.dart';

@JsonSerializable()
class ClassroomRoutineModel {
  static const DEFAULT_ASANA_DURATION = Duration(seconds: 30);

  @JsonKey(ignore: true)
  String uid;

  ///
  /// Reference to [AsanaModel.uniqueName]
  ///
  String asanaUniqueName;

  ///
  /// Duration for [AsanaModel] in [asanaUniqueName]
  ///
  @JsonKey(
    fromJson: _asanaDurationFromSeconds,
    toJson: _asanaDurationToSeconds,
  )
  Duration asanaDuration;

  ClassroomRoutineModel({
    String uid,
    this.asanaUniqueName,
    this.asanaDuration,
  })  : assert(asanaUniqueName != null),
        assert(asanaDuration != null),
        uid = uid ?? Uuid().v4();

  static Duration _asanaDurationFromSeconds(int seconds) => Duration(seconds: seconds);

  static int _asanaDurationToSeconds(Duration duration) => duration.inSeconds;

  factory ClassroomRoutineModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomRoutineModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassroomRoutineModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassroomRoutineModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          asanaUniqueName == other.asanaUniqueName &&
          asanaDuration == other.asanaDuration;

  @override
  int get hashCode => uid.hashCode ^ asanaUniqueName.hashCode ^ asanaDuration.hashCode;
}
