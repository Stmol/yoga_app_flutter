import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/repository/classroom_repository.dart';
import 'package:my_yoga_fl/utils/log.dart';

part 'classrooms_store.g.dart';

class ClassroomsStore = ClassroomsStoreBase with _$ClassroomsStore;

abstract class ClassroomsStoreBase with Store {
  final AbstractClassroomRepository classroomRepository;

  List<ClassroomModel> get classrooms => _classrooms.toList(growable: false);

  ReactionDisposer _saveReaction;

  @observable
  BuiltList<ClassroomModel> _classrooms = BuiltList<ClassroomModel>.of([]);

  @computed
  List<ClassroomModel> get predefinedClassrooms =>
      _classrooms.where((c) => c.isPredefined).toList(growable: false);

  @computed
  List<ClassroomModel> get usersClassrooms =>
      _classrooms.where((c) => c.isPredefined == false).toList(growable: false);

  ClassroomsStoreBase(this.classroomRepository);

  @action
  Future<void> init() async {
    Log.debug('Init classrooms store');

    /// First, try to get classrooms from storage
    final loadedClassrooms = await classroomRepository.getClassrooms();
    if (loadedClassrooms != null) {
      _classrooms = BuiltList<ClassroomModel>.from(loadedClassrooms);
    } else {
      /// If it empty or got error, obtain default classrooms from static JSON file
      final jsonString = await rootBundle.loadString('assets/data/classrooms.json');
      await _loadClassroomsFromJSON(jsonString).then((loaded) {
        _classrooms = _classrooms.rebuild((b) => b.addAll(loaded));
      });
    }

    _initReactions();
  }

  void _initReactions() {
    /// Flush classrooms entities to storage after any store modification
    _saveReaction = reaction<BuiltList<ClassroomModel>>(
      (_) => _classrooms,
      (list) => classroomRepository.saveClassrooms(list),
      // TODO: Add delay and onError
    );
  }

  void dispose() {
    _saveReaction();
  }

  @action
  void addClassroom(ClassroomModel classroom) {
    if (_classrooms.contains(classroom)) {
      // FIXME: Throw an exception
      Log.warn("Somehow you trying add existing classroom");
      return;
    }

    _classrooms = _classrooms.rebuild((b) => b.add(classroom));
  }

  @action
  void updateClassroom(ClassroomModel classroom) {
    // TODO: are you sure about id comparing?
    final replacementIndex = _classrooms.indexWhere((c) => c.id == classroom.id);
    if (replacementIndex == -1) {
      return;
    }

    // TODO: Async access to _classrooms before replacing by index?
    _classrooms = _classrooms.rebuild((b) => b[replacementIndex] = classroom);
  }

  @action
  void deleteClassroom(ClassroomModel classroom) {
    _classrooms = _classrooms.rebuild((b) => b.removeWhere((c) => c == classroom));
  }

  Future<List<ClassroomModel>> _loadClassroomsFromJSON(String jsonData) async {
    final List<dynamic> jsonDecoded = json.decode(jsonData);

    return jsonDecoded.map((e) => ClassroomModel.fromJSON(e)).toList();
  }
}
