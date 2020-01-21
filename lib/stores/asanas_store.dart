import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/utils/log.dart';

part 'asanas_store.g.dart';

class AsanasStore = AsanasStoreBase with _$AsanasStore;

abstract class AsanasStoreBase with Store {
  @observable
  BuiltList<AsanaModel> asanas = BuiltList.of([]);

  @action
  Future<void> initAsanas() async {
    await _loadAsanas();
  }

  List<AsanaModel> getAsanasInClassroom(ClassroomModel classroom) {
    if (classroom.asanasUniqueNames.isEmpty) {
      return [];
    }

    final classroomAsanas = classroom.asanasUniqueNames.map<AsanaModel>((uniqueName) {
      return asanas.singleWhere((a) => a.uniqueName == uniqueName, orElse: () => null);
    }).toList();

    classroomAsanas.removeWhere((a) => a == null);

    return classroomAsanas;
  }

  // TODO: Delete | Warning: don't use it!
  Future<void> refreshData() async {
    await _loadAsanas();
  }

  Future<void> _loadAsanas() async {
    Log.debug('Load asanas from JSON');

    await _loadAsanasFromJSON().then(
          (list) =>
      asanas = asanas.rebuild(
            (b) =>
        b
          ..clear()
          ..addAll(list)
          ..sort((a, b) => a.title.compareTo(b.title)),
      ),
    );
  }

  Future<List<AsanaModel>> _loadAsanasFromJSON() async {
    final jsonString = await rootBundle.loadString('assets/data/asanas.json');
    final List<dynamic> jsonDecoded = json.decode(jsonString);

    return jsonDecoded.map((e) => AsanaModel.fromJson(e)).toList();
  }
}
