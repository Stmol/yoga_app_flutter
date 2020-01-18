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
    Log.debug('Init asanas');
    await _loadAsanasFromJSON().then(
      (list) => asanas = asanas.rebuild(
        (b) => b.addAll(list),
      ),
    );
  }

  List<AsanaModel> getAsanasInClassroom(ClassroomModel classroom) {
    if (classroom.asanasUniqueNames.isEmpty) {
      return [];
    }

    return classroom.asanasUniqueNames.map<AsanaModel>((String uniqueName) {
      return asanas.firstWhere((a) => a.uniqueName == uniqueName);
    }).toList(growable: false);
  }

  Future<List<AsanaModel>> _loadAsanasFromJSON() async {
    final jsonString = await rootBundle.loadString('assets/data/asanas.json');
    final List<dynamic> jsonDecoded = json.decode(jsonString);

    return jsonDecoded.map((e) => AsanaModel.fromJson(e)).toList();
  }
}
