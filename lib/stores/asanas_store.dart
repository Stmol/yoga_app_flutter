import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_yoga_fl/models/classroom_model.dart';

part 'asanas_store.g.dart';

class AsanasStore = AsanasStoreBase with _$AsanasStore;

abstract class AsanasStoreBase with Store {
  @observable
  ObservableList<AsanaModel> asanas = ObservableList.of([]);

  @action
  Future<void> initAsanas() async {
    print('init asanas');
    await _loadAsanasFromJSON().then((a) => asanas.addAll(a));
  }

  List<AsanaModel> getAsanasForClassroom(ClassroomModel classroom) {
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

//class AsanasStore {
//  final _asanas = BehaviorSubject<List<AsanaModel>>();
//  Stream<List<AsanaModel>> get asanas => _asanas.asBroadcastStream();
//
//  AsanasStore() {
//    //final asanasListener = _asanas.listen((data) => print('new data!'));
//  }
//
//  Future<String> _loadAsanasString() async {
//    return await rootBundle.loadString('assets/data/asanas.json');
//  }
//
//  Future<void> loadAsanas() async {
//    String jsonString = await _loadAsanasString();
//    final jsonDecoded = json.decode(jsonString);
//
//    final asanas = List<AsanaModel>.from(jsonDecoded.map((jsonEntity) => AsanaModel.fromJson(jsonEntity)));
//    _asanas.add(asanas);
//  }
//
//  void dispose() {
//    _asanas.close();
//  }
//}
