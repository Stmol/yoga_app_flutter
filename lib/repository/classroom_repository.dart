import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractClassroomRepository {
  Future<List<ClassroomModel>> getClassrooms();

  Future saveClassrooms(BuiltList<ClassroomModel> classrooms);
}

class ClassroomKeyValueRepository implements AbstractClassroomRepository {
  final String key;
  final SharedPreferences sharedPreferences;

  const ClassroomKeyValueRepository(this.key, this.sharedPreferences);

  @override
  Future<List<ClassroomModel>> getClassrooms() async {
    if (sharedPreferences.containsKey(key) == false) {
      return null;
    }

    Log.debug('Loading <Classrooms> from SP storage');

    final jsonEncodedString = sharedPreferences.getString(key);

    try {
      final List<dynamic> jsonDecoded = json.decode(jsonEncodedString);

      return jsonDecoded.map((e) => ClassroomModel.fromJSON(e)).toList(growable: false);
    } catch(error) {
      Log.error(error); // TODO: Add error message

      await sharedPreferences.remove(key);

      return null;
    }
  }

  @override
  Future<bool> saveClassrooms(BuiltList<ClassroomModel> classrooms) {
    Log.debug('Saving <Classrooms> to SP storage');

    // TODO: Check correct way transforming to JSON
    final stringToSave = classrooms.map((c) => c.toJSON()).toList();

    return sharedPreferences.setString(key, json.encode(stringToSave));
  }
}
