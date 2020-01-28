import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/assets.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/utils/log.dart';

part 'asanas_store.g.dart';

class AsanasStore = AsanasStoreBase with _$AsanasStore;

abstract class AsanasStoreBase with Store {
  @observable
  BuiltMap<String, AsanaModel> asanas = BuiltMap<String, AsanaModel>.from({});

  @computed
  BuiltList<AsanaModel> get sortedAsanasList {
    final list = asanas.entries.map((m) => m.value).toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    return list.toBuiltList();
  }

  @action
  Future<void> init() async {
    await _loadAsanas();
  }

  List<AsanaModel> getAsanasInClassroom(ClassroomModel classroom) {
    if (classroom.classroomRoutines.isEmpty) {
      return [];
    }

    final classroomAsanas = classroom.classroomRoutines.map<AsanaModel>((routine) {
      return asanas[routine.asanaUniqueName];
    }).toList();

    classroomAsanas.removeWhere((a) => a == null);

    return classroomAsanas.toList(growable: false);
  }

  // TODO: Delete | Warning: don't use it!
  Future<void> refreshData() async {
    await _loadAsanas();
  }

  Future<void> _loadAsanas() async {
    Log.debug('Load asanas from JSON');

    final map = Map<String, AsanaModel>.from({});

    await _loadAsanasFromJSON().then(
      (asanaModels) => asanaModels.forEach((model) {
        map[model.uniqueName] = model;
      }),
    );

    asanas = MapBuilder<String, AsanaModel>(map).build();
  }

  Future<List<AsanaModel>> _loadAsanasFromJSON() async {
    final jsonString = await rootBundle.loadString(DataAssets.asanasJson);
    final List<dynamic> jsonDecoded = json.decode(jsonString);

    return jsonDecoded.map((e) => AsanaModel.fromJson(e)).toList();
  }
}
