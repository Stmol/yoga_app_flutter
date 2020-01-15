import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';

part 'classrooms_store.g.dart';

class ClassroomsStore = ClassroomsStoreBase with _$ClassroomsStore;

abstract class ClassroomsStoreBase with Store {
  List<ClassroomModel> get classrooms => _classrooms.toList(growable: false);

  @observable
  BuiltList<ClassroomModel> _classrooms = BuiltList<ClassroomModel>.of([]);

  @computed
  List<ClassroomModel> get predefinedClassrooms =>
      _classrooms.where((c) => c.isPredefined).toList(growable: false);

  @computed
  List<ClassroomModel> get usersClassrooms =>
      _classrooms.where((c) => c.isPredefined == false).toList(growable: false);

  @action
  Future<void> initClassrooms() async {
    print('init classrooms');
    await _loadClassroomsFromJSON().then((loaded) {
      _classrooms = _classrooms.rebuild((b) => b.addAll(loaded));
    });
  }

  @action
  void addClassroom(ClassroomModel model) {
    _classrooms = _classrooms.rebuild((b) => b.add(model));
  }

  @action
  void deleteClassroom(ClassroomModel model) {
    _classrooms = _classrooms.rebuild((b) => b.removeWhere((c) => c == model));
  }

  Future<List<ClassroomModel>> _loadClassroomsFromJSON() async {
    final jsonString = await rootBundle.loadString('assets/data/classrooms.json');
    final List<dynamic> jsonDecoded = json.decode(jsonString);

    return jsonDecoded.map((e) => ClassroomModel.fromJSON(e)).toList();
  }
}

// class ClassroomsStore {
//   final _classrooms = BehaviorSubject<List<ClassroomModel>>();
//   Stream<List<ClassroomModel>> get classrooms => _classrooms.asBroadcastStream();

//   Stream<List<ClassroomModel>> get predefinedClassrooms {
//     return _classrooms.asBroadcastStream().map((list) {
//       return list.where((classroom) {
//         print(classroom.isPredefined);
//         return classroom.isPredefined == true;
//       } );
//     });
//   }

//   Future<String> _loadClassroomsString() async {
//     return await rootBundle.loadString('assets/data/classrooms.json');
//   }

//   Future<void> loadClassrooms() async {
//     String jsonString = await _loadClassroomsString();
//     final List<dynamic> jsonDecoded = json.decode(jsonString);

//     final classrooms =
//         List<ClassroomModel>.from(jsonDecoded.map((e) => ClassroomModel.fromJSON(e)));
//     _classrooms.add(classrooms);
//   }

//   void dispose() {
//     _classrooms.close();
//   }
// }
